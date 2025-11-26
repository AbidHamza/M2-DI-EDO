# Architecture de l'application

## 📐 Vue d'ensemble

Cette API REST suit une architecture en couches (layered architecture) pour une séparation claire des responsabilités.

## 🏗️ Architecture en couches

```
┌─────────────────────────────────────┐
│         Routes (API Endpoints)      │  ← Interface HTTP
├─────────────────────────────────────┤
│         Services (Business Logic)   │  ← Logique métier
├─────────────────────────────────────┤
│         Models (SQLAlchemy)         │  ← Accès données
├─────────────────────────────────────┤
│         Database (PostgreSQL)       │  ← Stockage
└─────────────────────────────────────┘
```

## 📁 Structure détaillée

### 1. Routes (`app/routes/`)

**Responsabilité :** Gérer les requêtes HTTP et les réponses

```python
# app/routes/books.py
@router.get("/books")
def get_books(db: Session = Depends(get_db)):
    # Appelle le service
    return book_service.get_all_books(db)
```

**Rôle :**
- Définir les endpoints
- Valider les données d'entrée (via Pydantic)
- Appeler les services
- Retourner les réponses HTTP

### 2. Services (`app/services/`)

**Responsabilité :** Logique métier de l'application

```python
# app/services/book.py
def get_all_books(db: Session):
    # Logique métier
    books = db.query(Book).all()
    return books
```

**Rôle :**
- Implémenter la logique métier
- Interagir avec les modèles
- Gérer les règles business
- Gérer les erreurs métier

### 3. Models (`app/models/`)

**Responsabilité :** Représenter les données en base

```python
# app/models/book.py
class Book(Base):
    __tablename__ = "books"
    id = Column(Integer, primary_key=True)
    # ...
```

**Rôle :**
- Définir la structure des tables
- Gérer les relations entre tables
- Validation au niveau base de données

### 4. Schemas (`app/schemas/`)

**Responsabilité :** Validation et sérialisation des données

```python
# app/schemas/book.py
class BookCreate(BaseModel):
    title: str
    author: str
```

**Rôle :**
- Valider les données d'entrée
- Formater les données de sortie
- Conversion automatique des types

## 🔄 Flux de données

### Exemple : Créer un livre

```
1. Client HTTP
   POST /api/books
   {"title": "Mon livre", "author": "Auteur"}

2. Route (app/routes/books.py)
   - Reçoit la requête
   - Valide avec BookCreate schema
   - Appelle le service

3. Service (app/services/book.py)
   - Vérifie les règles métier
   - Crée l'objet Book
   - Sauvegarde en base via le modèle

4. Model (app/models/book.py)
   - Insère dans PostgreSQL
   - Retourne l'objet créé

5. Service
   - Retourne le livre créé

6. Route
   - Sérialise avec BookResponse schema
   - Retourne HTTP 201 avec les données

7. Client HTTP
   - Reçoit la réponse
```

## 🔐 Authentification

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │ 1. POST /auth/login
       ▼
┌─────────────┐
│   Route     │  auth.py
└──────┬──────┘
       │ 2. Vérifie credentials
       ▼
┌─────────────┐
│  Service    │  auth.py
└──────┬──────┘
       │ 3. Génère JWT
       ▼
┌─────────────┐
│   Route     │  Retourne token
└──────┬──────┘
       │ 4. Token JWT
       ▼
┌─────────────┐
│   Client    │  Stocke le token
└─────────────┘

Pour les requêtes suivantes :
┌─────────────┐
│   Client    │  Envoie token dans header
└──────┬──────┘
       │ Authorization: Bearer TOKEN
       ▼
┌─────────────┐
│ Middleware  │  auth.py - Vérifie le token
└──────┬──────┘
       │ Si valide → Continue
       │ Si invalide → 401
       ▼
┌─────────────┐
│   Route     │  Accès autorisé
└─────────────┘
```

## 🗄️ Modèle de données

### Relations

```
User (1) ──< (Many) Loan
Book (1) ──< (Many) Loan

User ──> Loan ──< Book
```

### Tables

- **users** : Utilisateurs de l'application
- **books** : Catalogue de livres
- **loans** : Prêts de livres (table de liaison)

## 🛡️ Sécurité

### Couches de sécurité

1. **Validation Pydantic** : Valide les données d'entrée
2. **Authentification JWT** : Vérifie l'identité
3. **Middleware** : Protège les routes
4. **Validation SQLAlchemy** : Contraintes au niveau base

## 📊 Gestion des erreurs

```
Erreur → Route → Service → Model
                ↓
         Exception Handler
                ↓
         HTTP Response (400, 404, 500)
```

## 🚀 Points d'extension

### Ajouter une nouvelle fonctionnalité

1. **Créer le modèle** : `app/models/new_model.py`
2. **Créer le schéma** : `app/schemas/new_model.py`
3. **Créer le service** : `app/services/new_model.py`
4. **Créer les routes** : `app/routes/new_model.py`
5. **Intégrer** : Ajouter dans `app/main.py`

---

**Cette architecture assure la maintenabilité et la scalabilité ! 🏗️**

