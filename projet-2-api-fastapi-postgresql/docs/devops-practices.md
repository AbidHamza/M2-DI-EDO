# Bonnes pratiques DevOps pour le projet

## 📋 Vue d'ensemble

Ce document présente les bonnes pratiques DevOps à suivre tout au long du projet. Ces pratiques vous aideront à développer de manière professionnelle et à faciliter le déploiement.

## 🔐 Gestion des secrets

### ❌ À NE JAMAIS FAIRE

```python
# ❌ MAUVAIS : Secrets en dur dans le code
SECRET_KEY = "mon-secret-key-12345"
DATABASE_URL = "postgresql://user:password@localhost/db"
```

### ✅ BONNES PRATIQUES

1. **Utiliser des variables d'environnement**
   ```python
   # ✅ BON : Depuis les variables d'environnement
   import os
   SECRET_KEY = os.getenv("SECRET_KEY")
   DATABASE_URL = os.getenv("DATABASE_URL")
   ```

2. **Créer un fichier .env.example**
   ```
   # .env.example (versionné)
   SECRET_KEY=your-secret-key-here
   DATABASE_URL=postgresql://user:password@localhost/db
   ```

3. **Ajouter .env au .gitignore**
   ```
   # .gitignore
   .env
   .env.local
   .env.*.local
   ```

4. **Utiliser python-dotenv en développement**
   ```python
   from dotenv import load_dotenv
   load_dotenv()  # Charge .env
   ```

## 📦 Gestion des dépendances

### requirements.txt

```txt
# Format recommandé avec versions exactes
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
```

### Bonnes pratiques

1. **Épingler les versions** : Utilisez `==` pour éviter les breaking changes
2. **Séparer dev et prod** : Créez `requirements-dev.txt` pour les outils de dev
3. **Mettre à jour régulièrement** : Vérifiez les mises à jour de sécurité

### requirements-dev.txt

```txt
# Outils de développement
pytest==7.4.3
pytest-cov==4.1.0
black==23.12.1
flake8==7.0.0
```

## 🔄 Versionnement Git

### Structure des commits

```bash
# Format recommandé
git commit -m "type: description courte"

# Types courants :
# feat: nouvelle fonctionnalité
# fix: correction de bug
# docs: documentation
# refactor: refactoring
# test: ajout de tests
```

### Exemples

```bash
git commit -m "feat: ajout authentification JWT"
git commit -m "fix: correction erreur connexion PostgreSQL"
git commit -m "docs: mise à jour README"
git commit -m "test: ajout tests pour API books"
```

### Branches

```bash
# Branche principale
main  # ou master

# Branches de fonctionnalité
feature/authentification
feature/api-books

# Branches de correction
fix/connexion-db
```

## 🧪 Tests

### Structure des tests

```
tests/
├── __init__.py
├── conftest.py          # Fixtures partagées
├── test_auth.py
├── test_books.py
└── test_loans.py
```

### Exécuter les tests

```bash
# Tous les tests
pytest

# Avec couverture
pytest --cov=app --cov-report=html

# Un fichier spécifique
pytest tests/test_auth.py

# Avec verbose
pytest -v
```

### Bonnes pratiques

1. **Nommer les tests clairement** : `test_create_user_success()`
2. **Un test = une assertion** : Testez une chose à la fois
3. **Tests isolés** : Chaque test doit être indépendant
4. **Fixtures pour les données** : Réutilisez les données de test

## 📝 Documentation

### Docstrings

```python
def create_user(db: Session, user_data: UserCreate) -> User:
    """
    Crée un nouvel utilisateur dans la base de données.
    
    Args:
        db: Session SQLAlchemy
        user_data: Données de l'utilisateur à créer
        
    Returns:
        User: L'utilisateur créé
        
    Raises:
        ValueError: Si l'email existe déjà
    """
    # ...
```

### Documentation API (Swagger)

FastAPI génère automatiquement la documentation, mais vous pouvez l'améliorer :

```python
@app.post(
    "/users",
    response_model=UserResponse,
    status_code=201,
    summary="Créer un utilisateur",
    description="Crée un nouvel utilisateur avec email et mot de passe",
    responses={
        201: {"description": "Utilisateur créé avec succès"},
        400: {"description": "Email déjà utilisé"}
    }
)
def create_user(user: UserCreate):
    # ...
```

## 🏗️ Structure du projet

### Organisation recommandée

```
app/
├── __init__.py
├── main.py              # Point d'entrée
├── config.py            # Configuration
├── database.py          # Connexion DB
├── models/              # Modèles SQLAlchemy
├── schemas/             # Schémas Pydantic
├── routes/              # Routes API
├── services/            # Logique métier
└── middleware/          # Middlewares
```

### Principes

1. **Séparation des responsabilités** : Chaque module a un rôle clair
2. **DRY (Don't Repeat Yourself)** : Évitez la duplication
3. **SOLID** : Principes de programmation orientée objet

## 🚀 Déploiement

### Variables d'environnement en production

```bash
# Ne jamais hardcoder
export SECRET_KEY="super-secret-key-from-secrets-manager"
export DATABASE_URL="postgresql://user:pass@host:port/db"
```

### Build et déploiement

```bash
# Installer les dépendances
pip install -r requirements.txt

# Build (si nécessaire)
# Pas de build pour Python, mais vérifiez les imports

# Démarrer
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### Health checks

```python
@app.get("/health")
def health_check():
    """Vérifie que l'API est opérationnelle."""
    return {"status": "OK"}
```

## 🔍 Logging

### Configuration

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)
```

### Utilisation

```python
logger.info("Utilisateur créé", extra={"user_id": user.id})
logger.error("Erreur de connexion", exc_info=True)
```

## ⚡ Performance

### Connexions à la base de données

```python
# ✅ BON : Pool de connexions
engine = create_engine(
    DATABASE_URL,
    pool_size=10,
    max_overflow=20
)
```

### Requêtes optimisées

```python
# ❌ MAUVAIS : N+1 queries
for user in users:
    print(user.books)  # Requête pour chaque utilisateur

# ✅ BON : Eager loading
users = db.query(User).options(joinedload(User.books)).all()
```

## 🛡️ Sécurité

### Validation des données

```python
# Toujours valider avec Pydantic
class UserCreate(BaseModel):
    email: EmailStr  # Validation automatique
    password: str = Field(..., min_length=8)
```

### Authentification

```python
# Vérifier les tokens
def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Token invalide")
```

### CORS en production

```python
# ❌ MAUVAIS : Autoriser toutes les origines
allow_origins=["*"]

# ✅ BON : Spécifier les origines
allow_origins=[
    "https://mon-domaine.com",
    "https://www.mon-domaine.com"
]
```

## 📊 Monitoring

### Métriques de base

```python
@app.get("/metrics")
def get_metrics():
    """Retourne les métriques de l'API."""
    return {
        "uptime": get_uptime(),
        "requests_count": get_requests_count(),
        "error_count": get_error_count()
    }
```

## ✅ Checklist avant déploiement

- [ ] Tous les secrets sont dans les variables d'environnement
- [ ] `.env` est dans `.gitignore`
- [ ] Tous les tests passent
- [ ] La documentation est à jour
- [ ] Les logs sont configurés
- [ ] CORS est correctement configuré
- [ ] Les erreurs sont gérées proprement
- [ ] La base de données est migrée
- [ ] Les variables d'environnement de production sont configurées

---

**Suivez ces pratiques pour un projet professionnel ! 🚀**

