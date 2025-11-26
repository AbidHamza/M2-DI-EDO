# Exercice Phase 1 : Configuration FastAPI

## 📝 Exercice à réaliser

Créez une application FastAPI simple avec les fonctionnalités suivantes :

1. **Route de bienvenue** : `/` qui retourne un message personnalisé
2. **Route de santé** : `/health` qui retourne le statut de l'API
3. **Route avec paramètre** : `/users/{user_id}` qui retourne l'ID de l'utilisateur
4. **Route POST** : `/users` qui accepte un nom et retourne un message de confirmation
5. **Configuration CORS** : Autoriser toutes les origines

## 🎯 Objectifs pédagogiques

- Comprendre la création de routes FastAPI
- Maîtriser les paramètres de route et de requête
- Configurer CORS
- Utiliser les types Python pour la validation

## 💻 Code à écrire

Créez un fichier `exercice_phase1.py` et implémentez les routes demandées.

**Indices :**
- Utilisez les décorateurs `@app.get()` et `@app.post()`
- Pour les paramètres de route, utilisez `{variable}` dans le chemin
- Pour les données POST, créez un modèle Pydantic ou utilisez `Body()`

## ✅ Correction complète

```python
from fastapi import FastAPI, Body
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional

# Créer l'instance FastAPI
app = FastAPI(
    title="Exercice Phase 1",
    description="Application d'exercice pour comprendre FastAPI",
    version="1.0.0"
)

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En production, spécifiez les origines autorisées
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modèle Pydantic pour les données POST
class UserCreate(BaseModel):
    name: str
    email: Optional[str] = None

# Route de bienvenue
@app.get("/")
def read_root():
    """
    Route racine qui retourne un message de bienvenue.
    
    Returns:
        dict: Message de bienvenue avec informations sur l'API
    """
    return {
        "message": "Bienvenue sur l'API d'exercice",
        "version": "1.0.0",
        "docs": "/docs"
    }

# Route de santé
@app.get("/health")
def health_check():
    """
    Route de santé pour vérifier que l'API fonctionne.
    Utilisée par les systèmes de monitoring.
    
    Returns:
        dict: Statut de l'API
    """
    return {
        "status": "OK",
        "message": "API is running"
    }

# Route avec paramètre de chemin
@app.get("/users/{user_id}")
def get_user(user_id: int):
    """
    Récupère un utilisateur par son ID.
    
    Args:
        user_id (int): L'identifiant de l'utilisateur
        
    Returns:
        dict: Informations sur l'utilisateur
    """
    # Note: Ici on simule juste la récupération
    # En réalité, on interrogerait la base de données
    return {
        "user_id": user_id,
        "message": f"Utilisateur {user_id} trouvé"
    }

# Route POST pour créer un utilisateur
@app.post("/users")
def create_user(user: UserCreate):
    """
    Crée un nouvel utilisateur.
    
    Args:
        user (UserCreate): Données de l'utilisateur à créer
        
    Returns:
        dict: Message de confirmation avec les données créées
    """
    return {
        "message": "Utilisateur créé avec succès",
        "user": {
            "name": user.name,
            "email": user.email
        }
    }

# Alternative avec Body() si on ne veut pas créer de modèle
@app.post("/users-simple")
def create_user_simple(
    name: str = Body(...),
    email: Optional[str] = Body(None)
):
    """
    Version alternative sans modèle Pydantic.
    
    Args:
        name (str): Nom de l'utilisateur (obligatoire)
        email (str, optional): Email de l'utilisateur
        
    Returns:
        dict: Message de confirmation
    """
    return {
        "message": f"Utilisateur {name} créé",
        "email": email
    }
```

## 📚 Explications détaillées

### 1. Import des modules

```python
from fastapi import FastAPI, Body
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
```

**Explication :**
- `FastAPI` : Classe principale du framework
- `Body` : Pour extraire les données du corps de la requête
- `CORSMiddleware` : Middleware pour gérer CORS (Cross-Origin Resource Sharing)
- `BaseModel` : Classe de base Pydantic pour créer des modèles de données
- `Optional` : Type Python pour indiquer qu'un paramètre est optionnel

### 2. Création de l'instance FastAPI

```python
app = FastAPI(
    title="Exercice Phase 1",
    description="Application d'exercice pour comprendre FastAPI",
    version="1.0.0"
)
```

**Explication :**
- `app` : Instance de l'application FastAPI
- `title`, `description`, `version` : Métadonnées affichées dans Swagger
- Ces informations apparaissent dans la documentation automatique

### 3. Configuration CORS

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Explication :**
- **CORS** : Permet aux navigateurs de faire des requêtes depuis d'autres domaines
- `allow_origins=["*"]` : Autorise toutes les origines (⚠️ à restreindre en production)
- `allow_credentials=True` : Permet l'envoi de cookies/credentials
- `allow_methods=["*"]` : Autorise toutes les méthodes HTTP (GET, POST, etc.)
- `allow_headers=["*"]` : Autorise tous les headers

**⚠️ Sécurité :** En production, remplacez `["*"]` par des listes spécifiques :
```python
allow_origins=["https://mon-domaine.com", "https://www.mon-domaine.com"]
```

### 4. Modèle Pydantic

```python
class UserCreate(BaseModel):
    name: str
    email: Optional[str] = None
```

**Explication :**
- `BaseModel` : Hérite de Pydantic pour la validation automatique
- `name: str` : Champ obligatoire de type string
- `email: Optional[str] = None` : Champ optionnel (peut être None)
- FastAPI valide automatiquement les données selon ce modèle

### 5. Route GET avec paramètre de chemin

```python
@app.get("/users/{user_id}")
def get_user(user_id: int):
    return {"user_id": user_id, "message": f"Utilisateur {user_id} trouvé"}
```

**Explication :**
- `@app.get()` : Décorateur pour une route GET
- `"/users/{user_id}"` : Chemin avec paramètre dynamique
- `user_id: int` : FastAPI convertit automatiquement en entier
- Si on envoie `/users/abc`, FastAPI retournera une erreur 422 (validation)

### 6. Route POST avec modèle Pydantic

```python
@app.post("/users")
def create_user(user: UserCreate):
    return {"message": "Utilisateur créé", "user": {"name": user.name, ...}}
```

**Explication :**
- `@app.post()` : Décorateur pour une route POST
- `user: UserCreate` : FastAPI valide automatiquement le JSON selon le modèle
- Si les données sont invalides, FastAPI retourne une erreur 422 avec détails

## 🧪 Comment tester

### 1. Démarrer le serveur

```bash
uvicorn exercice_phase1:app --reload
```

### 2. Tester avec Swagger UI

Ouvrez `http://localhost:8000/docs` et testez chaque endpoint :
- Cliquez sur un endpoint
- Cliquez sur "Try it out"
- Remplissez les paramètres
- Cliquez sur "Execute"

### 3. Tester avec curl

```bash
# Route GET
curl http://localhost:8000/

# Route avec paramètre
curl http://localhost:8000/users/123

# Route POST
curl -X POST http://localhost:8000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "email": "john@example.com"}'
```

## 🎓 Points clés à retenir

1. **Décorateurs** : `@app.get()`, `@app.post()` définissent les routes
2. **Types Python** : FastAPI utilise les types pour la validation automatique
3. **Pydantic** : Les modèles valident et convertissent les données
4. **CORS** : Nécessaire pour les requêtes depuis un navigateur
5. **Documentation automatique** : FastAPI génère Swagger automatiquement

## 🐛 Erreurs courantes

### Erreur : "422 Unprocessable Entity"
**Cause :** Les données envoyées ne correspondent pas au modèle
**Solution :** Vérifiez le format JSON et les types

### Erreur : "CORS policy"
**Cause :** CORS non configuré ou mal configuré
**Solution :** Vérifiez la configuration du middleware CORS

### Erreur : "Module not found"
**Cause :** Dépendances non installées
**Solution :** `pip install fastapi uvicorn`

## ✅ Checklist de validation

- [ ] Le serveur démarre sans erreur
- [ ] La route `/` fonctionne
- [ ] La route `/health` fonctionne
- [ ] La route `/users/{user_id}` fonctionne avec un entier
- [ ] La route `/users/{user_id}` retourne une erreur avec une chaîne
- [ ] La route POST `/users` accepte les données JSON
- [ ] La route POST valide les données (erreur si `name` manquant)
- [ ] La documentation Swagger est accessible
- [ ] CORS fonctionne (testez depuis un navigateur)

---

**Bravo ! Vous maîtrisez maintenant les bases de FastAPI ! 🎉**

