# Phase 1 : Configuration initiale de l'environnement

## 🎯 Objectif de la phase

Mettre en place l'environnement Python, installer FastAPI et créer la structure de base de votre projet. À la fin de cette phase, vous aurez un serveur FastAPI fonctionnel avec la documentation Swagger accessible.

## 📚 Rappels techniques essentiels

### Environnement virtuel Python
- **venv** : Module Python pour créer des environnements virtuels isolés
- **Isolation** : Chaque projet a ses propres dépendances
- **Activation** : Nécessaire pour utiliser l'environnement
- **Best Practice** : Toujours utiliser un environnement virtuel

### FastAPI
- **Framework moderne** : Basé sur les standards Python modernes
- **Performance** : Très rapide grâce à l'asynchrone
- **Documentation automatique** : Swagger/OpenAPI généré automatiquement
- **Validation** : Intégration native avec Pydantic

### Uvicorn
- **Serveur ASGI** : Serveur pour applications asynchrones
- **Hot Reload** : Rechargement automatique en développement
- **Performance** : Optimisé pour FastAPI

### Variables d'environnement
- **.env** : Fichier pour stocker les configurations (non versionné)
- **python-dotenv** : Package pour charger les variables
- **Sécurité** : Ne jamais commiter les fichiers `.env` avec des secrets

### Structure de projet Python
- **Packages** : Dossiers avec `__init__.py`
- **Modules** : Fichiers `.py`
- **Organisation** : Séparer les responsabilités (routes, services, modèles)

## 🏋️ Exercice pratique : Premier serveur FastAPI

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Créez une application FastAPI avec :
- Route de bienvenue `/`
- Route de santé `/health`
- Route avec paramètre `/users/{user_id}`
- Route POST `/users` pour créer un utilisateur
- Configuration CORS

**L'exercice complet avec :**
- ✅ Code à écrire
- ✅ Correction complète commentée ligne par ligne
- ✅ Explications détaillées de chaque concept
- ✅ Guide de test avec Swagger et curl
- ✅ Erreurs courantes et leurs solutions
- ✅ Checklist de validation

**Fichier :** `phases/phase-1-setup/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Créer l'environnement virtuel

1. À la racine du projet, créez un environnement virtuel :
   ```bash
   python -m venv venv
   ```

2. Activez l'environnement :
   ```bash
   # Windows
   venv\Scripts\activate
   # Linux/Mac
   source venv/bin/activate
   ```

3. Vérifiez que vous êtes dans le bon environnement (le prompt devrait afficher `(venv)`)

### Étape 2 : Installer les dépendances

1. Créez `requirements.txt` à la racine du projet avec ce contenu :
   ```
   fastapi==0.104.1
   uvicorn[standard]==0.24.0
   sqlalchemy==2.0.23
   psycopg2-binary==2.9.9
   python-dotenv==1.0.0
   pydantic==2.5.0
   pydantic-settings==2.1.0
   python-jose[cryptography]==3.3.0
   passlib[bcrypt]==1.7.4
   pytest==7.4.3
   pytest-asyncio==0.21.1
   httpx==0.25.2
   ```

2. Installez les dépendances :
   ```bash
   pip install -r requirements.txt
   ```

### Étape 3 : Créer la structure de dossiers

Créez la structure suivante :

```
projet-2-api-fastapi-postgresql/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── config.py
│   ├── database.py
│   ├── models/
│   │   └── __init__.py
│   ├── schemas/
│   │   └── __init__.py
│   ├── routes/
│   │   └── __init__.py
│   ├── services/
│   │   └── __init__.py
│   └── middleware/
│       └── __init__.py
├── tests/
│   └── __init__.py
├── requirements.txt
└── .env.example
```

**À faire :**
1. Créez tous les dossiers
2. Créez tous les fichiers `__init__.py` (même vides)
3. Ces fichiers indiquent à Python que ce sont des packages

### Étape 4 : Créer le fichier de configuration

Créez `app/config.py` :

**À faire :**
1. Importez `BaseSettings` de `pydantic_settings`
2. Créez une classe `Settings` qui hérite de `BaseSettings`
3. Définissez les variables :
   - `DATABASE_URL` : URL de connexion PostgreSQL (avec valeur par défaut)
   - `SECRET_KEY` : Clé secrète pour JWT (avec valeur par défaut)
   - `ALGORITHM` : Algorithme JWT ("HS256")
   - `ACCESS_TOKEN_EXPIRE_MINUTES` : Durée de vie du token (30)
   - `APP_NAME` : Nom de l'application
   - `DEBUG` : Mode debug (True)
4. Ajoutez une classe `Config` avec `env_file = ".env"`
5. Créez une instance `settings = Settings()`

**Indice :**
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/library_db"
    SECRET_KEY: str = "your-secret-key-change-in-production"
    # ... autres variables
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
```

### Étape 5 : Créer le point d'entrée

Créez `app/main.py` :

**À faire :**
1. Importez `FastAPI` et `CORSMiddleware`
2. Créez l'instance FastAPI avec titre et description
3. Configurez CORS (pour permettre les requêtes depuis le frontend)
4. Créez une route de santé `/api/health` qui retourne `{"status": "OK"}`
5. Créez une route racine `/` qui retourne un message de bienvenue

**Structure attendue :**
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Library Management API",
    description="API REST pour la gestion d'une bibliothèque",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(...)

@app.get("/")
def root():
    return {"message": "Welcome to Library Management API", "docs": "/docs"}

@app.get("/api/health")
def health_check():
    return {"status": "OK", "message": "API is running"}
```

### Étape 6 : Créer le fichier .env.example

Créez `.env.example` (template pour les variables d'environnement) :

```
DATABASE_URL=postgresql://user:password@localhost:5432/library_db
SECRET_KEY=your-secret-key-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
APP_NAME=Library Management API
DEBUG=True
```

### Étape 7 : Créer le fichier .env

1. Copiez `.env.example` vers `.env`
2. Modifiez les valeurs selon votre configuration locale
3. **IMPORTANT** : Ne commitez jamais le fichier `.env` !

### Étape 8 : Créer le .gitignore

Créez `.gitignore` à la racine :

```
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
ENV/

# Environment variables
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# Testing
.pytest_cache/
.coverage
htmlcov/

# Database
*.db
*.sqlite
```

### Étape 9 : Tester le serveur

1. Lancez le serveur :
   ```bash
   uvicorn app.main:app --reload
   ```

2. Ouvrez votre navigateur :
   - `http://localhost:8000` - Message de bienvenue
   - `http://localhost:8000/docs` - Documentation Swagger
   - `http://localhost:8000/api/health` - Route de santé

3. Testez dans Swagger UI :
   - Cliquez sur `/api/health`
   - Cliquez sur "Try it out"
   - Cliquez sur "Execute"
   - Vérifiez la réponse

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Environnement virtuel créé et activé
- [ ] Toutes les dépendances installées
- [ ] Structure de dossiers créée
- [ ] `app/config.py` avec la classe Settings
- [ ] `app/main.py` avec FastAPI configuré
- [ ] `.env.example` créé
- [ ] `.env` créé (non versionné)
- [ ] `.gitignore` configuré
- [ ] Le serveur démarre avec `uvicorn app.main:app --reload`
- [ ] La documentation Swagger est accessible
- [ ] Les routes de base fonctionnent

## 🧪 Vérification

Testez votre configuration :

1. **Serveur démarre :**
   ```bash
   uvicorn app.main:app --reload
   ```
   Devrait afficher : `Uvicorn running on http://127.0.0.1:8000`

2. **Documentation Swagger :**
   - Ouvrez `http://localhost:8000/docs`
   - Vous devriez voir l'interface Swagger avec vos routes

3. **Routes fonctionnent :**
   - Testez `/` : Devrait retourner le message de bienvenue
   - Testez `/api/health` : Devrait retourner `{"status": "OK"}`

## 🐛 Problèmes courants

- **ModuleNotFoundError** : Vérifiez que vous êtes dans l'environnement virtuel activé
- **Port déjà utilisé** : Changez le port avec `--port 8001` ou arrêtez le processus
- **Erreur d'import** : Vérifiez que vous êtes dans le bon répertoire
- **CORS errors** : Normal pour l'instant, sera configuré plus tard

## 📝 Notes importantes

- Gardez toujours votre environnement virtuel activé pendant le développement
- Le fichier `.env` ne doit JAMAIS être commité dans Git
- Utilisez `.env.example` comme template pour les autres développeurs
- La documentation Swagger est automatique - profitez-en !

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 2 : Configuration de PostgreSQL et SQLAlchemy**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 1: Configuration initiale de l'environnement"
```

