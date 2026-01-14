"""
Tests unitaires pour l'API exemple.
"""

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root():
    """Test de la route racine."""
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()

def test_create_item():
    """Test de création d'un item."""
    response = client.post(
        "/api/items",
        json={"name": "Test Item", "description": "Test", "price": 10.99}
    )
    assert response.status_code == 201
    assert response.json()["name"] == "Test Item"

def test_get_items():
    """Test de récupération des items."""
    response = client.get("/api/items")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_item_not_found():
    """Test de récupération d'un item inexistant."""
    response = client.get("/api/items/99999")
    assert response.status_code == 404

def test_health():
    """Test du health check."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

