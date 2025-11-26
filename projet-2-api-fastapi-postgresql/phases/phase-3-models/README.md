# Phase 3 : Modèles de données (SQLAlchemy Models)

## 🎯 Objectif de la phase

Créer les modèles SQLAlchemy pour User, Book et Loan avec leurs relations. Ces modèles représenteront les tables de votre base de données.

## 📚 Rappels techniques essentiels

### SQLAlchemy Models
- **Modèle** : Classe Python qui représente une table SQL
- **Héritage** : Tous les modèles héritent de `Base`
- **Colonnes** : Définies avec `Column(type, ...)`
- **Relations** : Définies avec `relationship()` et `ForeignKey`

### Types de colonnes SQLAlchemy
- **String(n)** : Texte avec longueur maximale
- **Integer** : Nombre entier
- **Boolean** : Vrai/Faux
- **DateTime** : Date et heure
- **Text** : Texte long sans limite
- **ForeignKey** : Clé étrangère vers une autre table

### Relations
- **One-to-Many** : Un utilisateur a plusieurs prêts (`relationship()` + `ForeignKey`)
- **Many-to-One** : Plusieurs prêts appartiennent à un livre
- **back_populates** : Définit la relation bidirectionnelle

### Timestamps automatiques
- **server_default** : Valeur par défaut côté serveur
- **onupdate** : Valeur mise à jour automatiquement
- **func.now()** : Fonction SQL pour la date actuelle

## 🏋️ Exercice pratique : Modèles avec Relations

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Créez un système complet de modèles pour une bibliothèque avec :
- Modèle `Author` (auteur)
- Modèle `Book` avec relation Many-to-One vers Author
- Modèle `Category` (catégorie)
- Relation Many-to-Many entre Book et Category
- Script de test complet des relations

**L'exercice complet avec :**
- ✅ Tous les modèles avec relations
- ✅ Table d'association pour Many-to-Many
- ✅ Explications détaillées des relations
- ✅ Script de test avec tous les cas d'usage
- ✅ Requêtes avancées avec relations

**Fichier :** `phases/phase-3-models/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Créer le modèle User

Créez `app/models/user.py` :

**Structure attendue :**
- `id` : Integer, clé primaire, indexé
- `username` : String(50), unique, indexé, non nullable
- `email` : String(100), unique, indexé, non nullable
- `hashed_password` : String(255), non nullable
- `is_active` : Boolean, défaut True
- `created_at` : DateTime, automatique avec `server_default=func.now()`
- `updated_at` : DateTime, automatique avec `onupdate=func.now()`
- Relation `loans` : One-to-Many vers Loan

**À faire :**
1. Importez les types nécessaires de SQLAlchemy
2. Importez `Base` depuis `app.database`
3. Créez la classe `User` qui hérite de `Base`
4. Définissez `__tablename__ = "users"`
5. Définissez toutes les colonnes avec leurs contraintes
6. Ajoutez la relation `loans = relationship("Loan", back_populates="user")`
7. Activez les timestamps automatiques

**Indice :**
```python
from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True, nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relations
    loans = relationship("Loan", back_populates="user", cascade="all, delete-orphan")
```

### Étape 2 : Créer le modèle Book

Créez `app/models/book.py` :

**Structure attendue :**
- `id` : Integer, clé primaire, indexé
- `title` : String(200), non nullable, indexé
- `author` : String(100), non nullable, indexé
- `isbn` : String(20), unique, indexé, optionnel
- `description` : Text, optionnel
- `is_available` : Boolean, défaut True
- `created_at` : DateTime, automatique
- `updated_at` : DateTime, automatique
- Relation `loans` : One-to-Many vers Loan

**À faire :**
1. Créez la classe `Book` similaire à `User`
2. Définissez toutes les colonnes
3. Ajoutez la relation vers Loan

### Étape 3 : Créer le modèle Loan

Créez `app/models/loan.py` :

**Structure attendue :**
- `id` : Integer, clé primaire, indexé
- `user_id` : Integer, ForeignKey vers User, non nullable
- `book_id` : Integer, ForeignKey vers Book, non nullable
- `loan_date` : DateTime, automatique avec `server_default=func.now()`
- `return_date` : DateTime, nullable (rempli lors du retour)
- `due_date` : DateTime, non nullable (date limite de retour)
- `is_returned` : Boolean, défaut False
- `created_at` : DateTime, automatique
- Relations : `user` et `book` (Many-to-One)

**À faire :**
1. Importez `ForeignKey` de SQLAlchemy
2. Créez la classe `Loan`
3. Définissez les ForeignKey vers User et Book
4. Ajoutez les relations bidirectionnelles avec `back_populates`

**Indice :**
```python
from sqlalchemy import Column, Integer, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base

class Loan(Base):
    __tablename__ = "loans"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    book_id = Column(Integer, ForeignKey("books.id"), nullable=False)
    loan_date = Column(DateTime(timezone=True), server_default=func.now())
    return_date = Column(DateTime(timezone=True), nullable=True)
    due_date = Column(DateTime(timezone=True), nullable=False)
    is_returned = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relations
    user = relationship("User", back_populates="loans")
    book = relationship("Book", back_populates="loans")
```

### Étape 4 : Exporter les modèles

Dans `app/models/__init__.py` :

**À faire :**
1. Importez tous les modèles
2. Exportez-les pour faciliter les imports

```python
from app.models.user import User
from app.models.book import Book
from app.models.loan import Loan

__all__ = ["User", "Book", "Loan"]
```

### Étape 5 : Créer les tables dans la base de données

Dans `app/main.py`, assurez-vous d'avoir :

```python
from app.database import Base, engine
from app.models import User, Book, Loan  # Import pour créer les tables

# Créer les tables
Base.metadata.create_all(bind=engine)
```

**⚠️ Important :** Cette méthode est pour le développement. En production, utilisez Alembic pour les migrations.

### Étape 6 : Tester la création des tables

1. Démarrez le serveur :
   ```bash
   uvicorn app.main:app --reload
   ```

2. Vérifiez dans PostgreSQL :
   ```sql
   psql -U postgres -d library_db
   \dt  -- Liste les tables
   ```

3. Vérifiez la structure d'une table :
   ```sql
   \d users  -- Détails de la table users
   ```

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `app/models/user.py` avec le modèle User complet
- [ ] `app/models/book.py` avec le modèle Book complet
- [ ] `app/models/loan.py` avec le modèle Loan complet
- [ ] `app/models/__init__.py` exportant tous les modèles
- [ ] Les tables créées dans PostgreSQL
- [ ] Les relations correctement définies
- [ ] Vous pouvez voir les tables avec `\dt` dans psql

## 🧪 Vérification

Testez vos modèles :

1. **Vérifier les tables :**
   ```sql
   \dt
   ```
   Devrait afficher : `users`, `books`, `loans`

2. **Vérifier les relations :**
   ```sql
   \d loans
   ```
   Devrait afficher les ForeignKey vers `users` et `books`

3. **Test d'insertion (optionnel) :**
   ```python
   from app.database import SessionLocal
   from app.models import User
   
   db = SessionLocal()
   user = User(username="test", email="test@test.com", hashed_password="hash")
   db.add(user)
   db.commit()
   print("✅ Utilisateur créé !")
   ```

## 🐛 Problèmes courants

- **Erreur "Table already exists"** : Normal si vous relancez, les tables existent déjà
- **Erreur de ForeignKey** : Vérifiez que les noms de tables correspondent
- **Erreur d'import** : Vérifiez les imports circulaires
- **Relations ne fonctionnent pas** : Vérifiez `back_populates` des deux côtés

## 📝 Notes importantes

- **Cascade** : `cascade="all, delete-orphan"` supprime les prêts si l'utilisateur est supprimé
- **Index** : Les colonnes indexées (`index=True`) accélèrent les recherches
- **Unique** : `unique=True` empêche les doublons
- **Nullable** : `nullable=False` rend le champ obligatoire

## 🔍 Comprendre les relations

**User → Loans (One-to-Many) :**
- Un utilisateur peut avoir plusieurs prêts
- `loans = relationship("Loan", back_populates="user")`

**Loan → User (Many-to-One) :**
- Plusieurs prêts appartiennent à un utilisateur
- `user_id = ForeignKey("users.id")`
- `user = relationship("User", back_populates="loans")`

Même logique pour Book ↔ Loans.

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 4 : Schémas Pydantic (Validation)**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 3: Modèles SQLAlchemy (User, Book, Loan) avec relations"
```

