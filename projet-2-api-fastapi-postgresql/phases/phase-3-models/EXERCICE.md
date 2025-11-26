# Exercice Phase 3 : Modèles SQLAlchemy avec Relations

## 📝 Exercice à réaliser

Créez un système de modèles avec relations pour une bibliothèque :

1. **Modèle Author** : Auteur de livres
   - id, name, email, created_at

2. **Modèle Book** : Livre
   - id, title, isbn, author_id (ForeignKey vers Author)
   - Relation Many-to-One avec Author

3. **Modèle Category** : Catégorie de livre
   - id, name, description

4. **Relation Many-to-Many** : Book ↔ Category
   - Table d'association `book_categories`

5. Créez les tables et testez les relations

## 🎯 Objectifs pédagogiques

- Comprendre les relations One-to-Many
- Maîtriser les relations Many-to-Many
- Utiliser les ForeignKey
- Comprendre `relationship()` et `back_populates`
- Utiliser les tables d'association

## 💻 Code à écrire

Créez les modèles avec toutes les relations et un script de test.

## ✅ Correction complète

```python
"""
Exercice Phase 3 : Modèles SQLAlchemy avec Relations
Démontre les relations One-to-Many et Many-to-Many
"""

from sqlalchemy import (
    Column, Integer, String, DateTime, ForeignKey, Table,
    create_engine
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.sql import func
from datetime import datetime, timedelta

# ============================================
# 1. CONFIGURATION
# ============================================

DATABASE_URL = "postgresql://postgres:password@localhost:5432/library_exercise"
engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()


# ============================================
# 2. TABLE D'ASSOCIATION (Many-to-Many)
# ============================================

# Table d'association pour la relation Many-to-Many entre Book et Category
# Cette table n'a pas de modèle Python, c'est juste une table SQL
book_categories = Table(
    'book_categories',
    Base.metadata,
    Column('book_id', Integer, ForeignKey('books.id'), primary_key=True),
    Column('category_id', Integer, ForeignKey('categories.id'), primary_key=True)
)

"""
Explication de la table d'association :
- book_categories : Nom de la table
- book_id : Clé étrangère vers books.id
- category_id : Clé étrangère vers categories.id
- primary_key=True sur les deux : Clé primaire composite
  (un livre ne peut pas être dans la même catégorie deux fois)
"""


# ============================================
# 3. MODÈLE AUTHOR
# ============================================

class Author(Base):
    """
    Modèle représentant un auteur.
    
    Relations:
        - One-to-Many avec Book (un auteur peut avoir plusieurs livres)
    """
    __tablename__ = "authors"
    
    # Colonnes
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, index=True)
    email = Column(String(100), unique=True, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relation One-to-Many avec Book
    # Un auteur peut avoir plusieurs livres
    books = relationship(
        "Book",
        back_populates="author",  # Définit la relation bidirectionnelle
        cascade="all, delete-orphan"  # Si l'auteur est supprimé, ses livres aussi
    )
    
    def __repr__(self):
        return f"<Author(id={self.id}, name='{self.name}')>"


# ============================================
# 4. MODÈLE CATEGORY
# ============================================

class Category(Base):
    """
    Modèle représentant une catégorie de livre.
    
    Relations:
        - Many-to-Many avec Book (via book_categories)
    """
    __tablename__ = "categories"
    
    # Colonnes
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    description = Column(String(500), nullable=True)
    
    # Relation Many-to-Many avec Book
    # secondary : Spécifie la table d'association
    books = relationship(
        "Book",
        secondary=book_categories,  # Table d'association
        back_populates="categories"  # Relation bidirectionnelle
    )
    
    def __repr__(self):
        return f"<Category(id={self.id}, name='{self.name}')>"


# ============================================
# 5. MODÈLE BOOK
# ============================================

class Book(Base):
    """
    Modèle représentant un livre.
    
    Relations:
        - Many-to-One avec Author (plusieurs livres, un auteur)
        - Many-to-Many avec Category (via book_categories)
    """
    __tablename__ = "books"
    
    # Colonnes
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False, index=True)
    isbn = Column(String(20), unique=True, nullable=True)
    
    # ForeignKey vers Author (Many-to-One)
    author_id = Column(
        Integer,
        ForeignKey("authors.id"),  # Référence la table authors
        nullable=False
    )
    
    # Relation Many-to-One avec Author
    # Un livre appartient à un auteur
    author = relationship(
        "Author",
        back_populates="books"  # Relation bidirectionnelle
    )
    
    # Relation Many-to-Many avec Category
    categories = relationship(
        "Category",
        secondary=book_categories,  # Table d'association
        back_populates="books"  # Relation bidirectionnelle
    )
    
    def __repr__(self):
        return f"<Book(id={self.id}, title='{self.title}', author_id={self.author_id})>"


# ============================================
# 6. CRÉATION DES TABLES
# ============================================

def create_tables():
    """Crée toutes les tables dans la base de données."""
    print("🔄 Création des tables...")
    Base.metadata.create_all(bind=engine)
    print("✅ Tables créées!")


# ============================================
# 7. SCRIPT DE TEST
# ============================================

def test_relations():
    """
    Teste toutes les relations entre les modèles.
    """
    db = SessionLocal()
    
    try:
        print("\n" + "=" * 60)
        print("TEST DES RELATIONS")
        print("=" * 60)
        
        # ========================================
        # 1. CRÉER DES AUTEURS
        # ========================================
        print("\n1️⃣ Création d'auteurs...")
        
        author1 = Author(name="J.K. Rowling", email="jk@example.com")
        author2 = Author(name="George R.R. Martin", email="grrm@example.com")
        
        db.add(author1)
        db.add(author2)
        db.commit()
        db.refresh(author1)
        db.refresh(author2)
        
        print(f"✅ Auteur créé: {author1}")
        print(f"✅ Auteur créé: {author2}")
        
        # ========================================
        # 2. CRÉER DES CATÉGORIES
        # ========================================
        print("\n2️⃣ Création de catégories...")
        
        category1 = Category(name="Fantasy", description="Livres de fantasy")
        category2 = Category(name="Science Fiction", description="Sci-Fi")
        category3 = Category(name="Adventure", description="Aventures")
        
        db.add_all([category1, category2, category3])
        db.commit()
        
        print(f"✅ Catégories créées")
        
        # ========================================
        # 3. CRÉER DES LIVRES (avec relation One-to-Many)
        # ========================================
        print("\n3️⃣ Création de livres avec auteurs...")
        
        # Méthode 1 : Assigner directement l'auteur
        book1 = Book(
            title="Harry Potter and the Philosopher's Stone",
            isbn="978-0747532699",
            author_id=author1.id  # ForeignKey directe
        )
        
        # Méthode 2 : Utiliser la relation (plus Pythonique)
        book2 = Book(
            title="Harry Potter and the Chamber of Secrets",
            isbn="978-0747538493"
        )
        book2.author = author1  # Utilise la relation
        
        book3 = Book(
            title="A Game of Thrones",
            isbn="978-0553103540",
            author_id=author2.id
        )
        
        db.add_all([book1, book2, book3])
        db.commit()
        db.refresh(book1)
        db.refresh(book2)
        db.refresh(book3)
        
        print(f"✅ Livre créé: {book1}")
        print(f"✅ Livre créé: {book2}")
        print(f"✅ Livre créé: {book3}")
        
        # ========================================
        # 4. TESTER LA RELATION One-to-Many (Author → Books)
        # ========================================
        print("\n4️⃣ Test relation One-to-Many (Auteur → Livres)...")
        
        # Récupérer l'auteur avec ses livres
        author_with_books = db.query(Author).filter(Author.id == author1.id).first()
        
        print(f"\n📚 Auteur: {author_with_books.name}")
        print(f"   Livres écrits ({len(author_with_books.books)}):")
        for book in author_with_books.books:
            print(f"   - {book.title}")
        
        # ========================================
        # 5. TESTER LA RELATION Many-to-One (Book → Author)
        # ========================================
        print("\n5️⃣ Test relation Many-to-One (Livre → Auteur)...")
        
        book_with_author = db.query(Book).filter(Book.id == book1.id).first()
        
        print(f"\n📖 Livre: {book_with_author.title}")
        print(f"   Auteur: {book_with_author.author.name}")
        print(f"   Email auteur: {book_with_author.author.email}")
        
        # ========================================
        # 6. CRÉER LA RELATION Many-to-Many (Book ↔ Category)
        # ========================================
        print("\n6️⃣ Création relation Many-to-Many (Livre ↔ Catégorie)...")
        
        # Méthode 1 : Ajouter des catégories à un livre
        book1.categories.append(category1)  # Fantasy
        book1.categories.append(category3)  # Adventure
        
        # Méthode 2 : Ajouter un livre à une catégorie (bidirectionnel)
        category2.books.append(book3)  # Sci-Fi pour A Game of Thrones
        
        db.commit()
        
        print(f"✅ Catégories assignées aux livres")
        
        # ========================================
        # 7. TESTER LA RELATION Many-to-Many
        # ========================================
        print("\n7️⃣ Test relation Many-to-Many...")
        
        # Depuis un livre : voir ses catégories
        book_with_categories = db.query(Book).filter(Book.id == book1.id).first()
        print(f"\n📖 Livre: {book_with_categories.title}")
        print(f"   Catégories ({len(book_with_categories.categories)}):")
        for category in book_with_categories.categories:
            print(f"   - {category.name}: {category.description}")
        
        # Depuis une catégorie : voir ses livres
        category_with_books = db.query(Category).filter(Category.id == category1.id).first()
        print(f"\n📂 Catégorie: {category_with_books.name}")
        print(f"   Livres ({len(category_with_books.books)}):")
        for book in category_with_books.books:
            print(f"   - {book.title} (par {book.author.name})")
        
        # ========================================
        # 8. REQUÊTES AVANCÉES
        # ========================================
        print("\n8️⃣ Requêtes avancées...")
        
        # Tous les livres d'un auteur avec leurs catégories
        author = db.query(Author).filter(Author.name == "J.K. Rowling").first()
        print(f"\n📚 Tous les livres de {author.name}:")
        for book in author.books:
            categories = ", ".join([c.name for c in book.categories])
            print(f"   - {book.title} [{categories}]")
        
        # Tous les livres d'une catégorie avec leurs auteurs
        category = db.query(Category).filter(Category.name == "Fantasy").first()
        print(f"\n📂 Tous les livres de la catégorie '{category.name}':")
        for book in category.books:
            print(f"   - {book.title} (par {book.author.name})")
        
        print("\n" + "=" * 60)
        print("✅ TOUS LES TESTS RÉUSSIS!")
        print("=" * 60)
        
    except Exception as e:
        db.rollback()
        print(f"\n❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
        
    finally:
        db.close()


# ============================================
# 8. POINT D'ENTRÉE
# ============================================

if __name__ == "__main__":
    print("=" * 60)
    print("EXERCICE PHASE 3 : MODÈLES AVEC RELATIONS")
    print("=" * 60)
    
    # Créer les tables
    create_tables()
    
    # Tester les relations
    test_relations()
```

## 📚 Explications détaillées

### 1. Table d'association (Many-to-Many)

```python
book_categories = Table(
    'book_categories',
    Base.metadata,
    Column('book_id', Integer, ForeignKey('books.id'), primary_key=True),
    Column('category_id', Integer, ForeignKey('categories.id'), primary_key=True)
)
```

**Explication :**
- **Table** : Crée une table SQL sans modèle Python
- **primary_key=True sur les deux** : Clé primaire composite
- **Pourquoi ?** : Un livre peut être dans plusieurs catégories, une catégorie peut contenir plusieurs livres
- **Pas de modèle Python** : On accède via les relations, pas directement

### 2. Relation One-to-Many (Author → Books)

```python
# Dans Author
books = relationship("Book", back_populates="author", cascade="all, delete-orphan")

# Dans Book
author_id = Column(Integer, ForeignKey("authors.id"), nullable=False)
author = relationship("Author", back_populates="books")
```

**Explication :**
- **ForeignKey** : Dans la table "many" (Book), on stocke l'ID de "one" (Author)
- **relationship()** : Permet d'accéder aux objets Python directement
- **back_populates** : Définit la relation bidirectionnelle
- **cascade** : Si l'auteur est supprimé, ses livres aussi

**Schéma :**
```
Author (1) ──< (Many) Book
```

### 3. Relation Many-to-Many (Book ↔ Category)

```python
# Dans Book
categories = relationship("Category", secondary=book_categories, back_populates="books")

# Dans Category
books = relationship("Book", secondary=book_categories, back_populates="categories")
```

**Explication :**
- **secondary** : Spécifie la table d'association
- **Pas de ForeignKey direct** : La relation passe par la table d'association
- **Bidirectionnel** : On peut accéder depuis Book ou Category

**Schéma :**
```
Book (Many) ──< book_categories >── (Many) Category
```

### 4. Utilisation des relations

```python
# One-to-Many : Depuis Author
author.books  # Liste de tous les livres de l'auteur

# Many-to-One : Depuis Book
book.author  # L'auteur du livre
book.author.name  # Le nom de l'auteur

# Many-to-Many : Depuis Book
book.categories  # Liste des catégories du livre
book.categories.append(category)  # Ajouter une catégorie

# Many-to-Many : Depuis Category
category.books  # Liste des livres de la catégorie
```

### 5. Assignation des relations

```python
# Méthode 1 : Via ForeignKey
book = Book(author_id=author.id)

# Méthode 2 : Via relation (plus Pythonique)
book = Book()
book.author = author

# Méthode 3 : Via liste (One-to-Many)
author.books.append(book)
```

## 🧪 Comment tester

1. **Créer la base de données :**
   ```sql
   CREATE DATABASE library_exercise;
   ```

2. **Exécuter le script :**
   ```bash
   python exercice_phase3.py
   ```

3. **Vérifier dans PostgreSQL :**
   ```sql
   \c library_exercise
   \dt  -- Voir les tables
   SELECT * FROM authors;
   SELECT * FROM books;
   SELECT * FROM categories;
   SELECT * FROM book_categories;  -- Table d'association
   ```

## 🎓 Points clés à retenir

1. **ForeignKey** : Toujours dans la table "many" pour One-to-Many
2. **relationship()** : Accès Pythonique aux objets liés
3. **back_populates** : Nécessaire pour la bidirectionnalité
4. **secondary** : Pour les relations Many-to-Many
5. **cascade** : Définit le comportement lors de la suppression

## 🐛 Erreurs courantes

### Erreur : "back_populates mismatch"
**Cause :** Les noms dans `back_populates` ne correspondent pas
**Solution :** Vérifiez que les noms sont identiques des deux côtés

### Erreur : "secondary table not found"
**Cause :** La table d'association n'est pas créée
**Solution :** Vérifiez que `Base.metadata.create_all()` est appelé

### Erreur : "Cannot add object"
**Cause :** Objet non dans la session
**Solution :** Utilisez `db.add()` ou assignez directement via la relation

## ✅ Checklist de validation

- [ ] Les tables sont créées (authors, books, categories, book_categories)
- [ ] Vous pouvez créer un auteur avec ses livres
- [ ] `author.books` retourne la liste des livres
- [ ] `book.author` retourne l'auteur
- [ ] Vous pouvez assigner des catégories à un livre
- [ ] `book.categories` retourne les catégories
- [ ] `category.books` retourne les livres
- [ ] Les requêtes avec relations fonctionnent

---

**Parfait ! Vous maîtrisez maintenant les relations SQLAlchemy ! 🎉**

