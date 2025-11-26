# Phase 4 : Schémas Pydantic (Validation)

## 🎯 Objectif de la phase

Créer les schémas Pydantic pour valider les données d'entrée et de sortie de l'API. Les schémas garantissent que les données sont correctes avant traitement.

## 📚 Rappels techniques essentiels

### Pydantic
- **Pydantic** : Bibliothèque de validation de données avec typage
- **BaseModel** : Classe de base pour créer des schémas
- **Validation automatique** : FastAPI valide automatiquement avec Pydantic
- **Conversion de types** : Conversion automatique des types

### Types Pydantic
- **str, int, float, bool** : Types de base
- **Optional[T]** : Type optionnel (peut être None)
- **EmailStr** : Validation d'email
- **Field()** : Contraintes supplémentaires (min_length, max_length, etc.)

### Schémas courants
- **Create** : Données pour créer une ressource
- **Update** : Données pour mettre à jour (tous les champs optionnels)
- **Response** : Données retournées (sans secrets)

## 🏋️ Exercice pratique : Schémas Pydantic

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Créez des schémas Pydantic complets pour :
- User (Create, Login, Response)
- Book (Create, Update, Response)
- Validation avancée avec Field()
- Tests de validation

**Fichier :** `phases/phase-4-schemas/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Créer les schémas User

Créez `app/schemas/user.py` :

**Schémas à créer :**

1. **UserBase** (schéma de base) :
   - `username: str` (min 3, max 50)
   - `email: EmailStr`

2. **UserCreate** (hérite de UserBase) :
   - `password: str` (min 6 caractères)

3. **UserLogin** :
   - `email: EmailStr`
   - `password: str`

4. **UserResponse** (hérite de UserBase) :
   - `id: int`
   - `is_active: bool`
   - `created_at: datetime`

5. **Token** :
   - `access_token: str`
   - `token_type: str` (défaut "bearer")
   - `user: UserResponse`

**À faire :**
- Utilisez `Field()` pour les contraintes
- Utilisez `EmailStr` pour l'email
- Ajoutez `from_attributes = True` dans Config pour UserResponse

### Étape 2 : Créer les schémas Book

Créez `app/schemas/book.py` :

**Schémas à créer :**

1. **BookBase** :
   - `title: str` (min 1, max 200)
   - `author: str` (min 1, max 100)
   - `isbn: Optional[str]` (max 20)
   - `description: Optional[str]`

2. **BookCreate** (hérite de BookBase) :
   - Tous les champs de BookBase

3. **BookUpdate** :
   - Tous les champs optionnels (pour mise à jour partielle)

4. **BookResponse** (hérite de BookBase) :
   - `id: int`
   - `is_available: bool`
   - `created_at: datetime`
   - `updated_at: Optional[datetime]`

### Étape 3 : Créer les schémas Loan

Créez `app/schemas/loan.py` :

**Schémas à créer :**

1. **LoanCreate** :
   - `book_id: int`

2. **LoanResponse** :
   - `id: int`
   - `user_id: int`
   - `book_id: int`
   - `loan_date: datetime`
   - `return_date: Optional[datetime]`
   - `due_date: datetime`
   - `is_returned: bool`
   - `created_at: datetime`
   - `user: Optional[UserResponse]` (relation)
   - `book: Optional[BookResponse]` (relation)

### Étape 4 : Exporter les schémas

Dans `app/schemas/__init__.py` :

```python
from app.schemas.user import UserCreate, UserResponse, UserLogin, Token
from app.schemas.book import BookCreate, BookResponse, BookUpdate
from app.schemas.loan import LoanCreate, LoanResponse

__all__ = [
    "UserCreate", "UserResponse", "UserLogin", "Token",
    "BookCreate", "BookResponse", "BookUpdate",
    "LoanCreate", "LoanResponse"
]
```

### Étape 5 : Tester la validation

Créez un script de test `test_schemas.py` :

```python
from app.schemas.user import UserCreate

# Test validation
try:
    user = UserCreate(
        username="ab",  # Trop court
        email="invalid-email",  # Email invalide
        password="123"  # Trop court
    )
except Exception as e:
    print(f"✅ Validation fonctionne: {e}")
```

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `app/schemas/user.py` avec tous les schémas User
- [ ] `app/schemas/book.py` avec tous les schémas Book
- [ ] `app/schemas/loan.py` avec tous les schémas Loan
- [ ] `app/schemas/__init__.py` exportant tous les schémas
- [ ] Les validations fonctionnent (testez avec des données invalides)
- [ ] Les schémas sont utilisables dans FastAPI

## 🧪 Vérification

Testez vos schémas :

1. **Test de validation :**
   ```python
   from app.schemas.user import UserCreate
   
   # Devrait échouer
   user = UserCreate(username="ab", email="invalid", password="123")
   ```

2. **Test dans FastAPI :**
   - Créez une route de test
   - Envoyez des données invalides
   - Vérifiez que FastAPI retourne une erreur 422

## 🐛 Problèmes courants

- **Erreur "field required"** : Vérifiez que tous les champs obligatoires sont présents
- **Erreur de type** : Vérifiez les types Python (str, int, etc.)
- **EmailStr non reconnu** : Installez `email-validator` : `pip install email-validator`

## 📝 Notes importantes

- **from_attributes** : Nécessaire pour convertir les modèles SQLAlchemy en schémas
- **Optional** : Utilisez pour les champs qui peuvent être None
- **Field()** : Permet d'ajouter des contraintes (min_length, max_length, etc.)

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 5 : Authentification JWT**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 4: Schémas Pydantic avec validation"
```

