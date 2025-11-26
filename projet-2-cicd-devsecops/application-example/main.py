"""
Application exemple pour le déploiement CI/CD.
API REST simple avec FastAPI pour gérer des items.
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import sqlite3
from datetime import datetime

app = FastAPI(
    title="Example API",
    description="API exemple pour CI/CD",
    version="1.0.0"
)

# Modèle de données
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float

class ItemResponse(Item):
    id: int
    created_at: str

# Base de données simple (SQLite)
def init_db():
    """Initialise la base de données."""
    conn = sqlite3.connect('items.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            created_at TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

init_db()

@app.get("/")
def root():
    """Page d'accueil avec documentation."""
    return {
        "message": "Example API for CI/CD",
        "docs": "/docs",
        "version": "1.0.0"
    }

@app.get("/api/items", response_model=List[ItemResponse])
def get_items():
    """Récupère tous les items."""
    conn = sqlite3.connect('items.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM items')
    rows = cursor.fetchall()
    conn.close()
    
    items = []
    for row in rows:
        items.append(ItemResponse(
            id=row[0],
            name=row[1],
            description=row[2],
            price=row[3],
            created_at=row[4]
        ))
    
    return items

@app.post("/api/items", response_model=ItemResponse, status_code=201)
def create_item(item: Item):
    """Crée un nouvel item."""
    conn = sqlite3.connect('items.db')
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO items (name, description, price, created_at) VALUES (?, ?, ?, ?)',
        (item.name, item.description, item.price, datetime.now().isoformat())
    )
    item_id = cursor.lastrowid
    conn.commit()
    conn.close()
    
    return ItemResponse(
        id=item_id,
        name=item.name,
        description=item.description,
        price=item.price,
        created_at=datetime.now().isoformat()
    )

@app.get("/api/items/{item_id}", response_model=ItemResponse)
def get_item(item_id: int):
    """Récupère un item par ID."""
    conn = sqlite3.connect('items.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM items WHERE id = ?', (item_id,))
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Item not found")
    
    return ItemResponse(
        id=row[0],
        name=row[1],
        description=row[2],
        price=row[3],
        created_at=row[4]
    )

@app.put("/api/items/{item_id}", response_model=ItemResponse)
def update_item(item_id: int, item: Item):
    """Met à jour un item."""
    conn = sqlite3.connect('items.db')
    cursor = conn.cursor()
    cursor.execute(
        'UPDATE items SET name = ?, description = ?, price = ? WHERE id = ?',
        (item.name, item.description, item.price, item_id)
    )
    conn.commit()
    conn.close()
    
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Item not found")
    
    return ItemResponse(
        id=item_id,
        name=item.name,
        description=item.description,
        price=item.price,
        created_at=datetime.now().isoformat()
    )

@app.delete("/api/items/{item_id}", status_code=204)
def delete_item(item_id: int):
    """Supprime un item."""
    conn = sqlite3.connect('items.db')
    cursor = conn.cursor()
    cursor.execute('DELETE FROM items WHERE id = ?', (item_id,))
    conn.commit()
    conn.close()
    
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Item not found")
    
    return None

@app.get("/health")
def health():
    """Health check endpoint."""
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

