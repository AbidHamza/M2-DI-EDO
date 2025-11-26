# Exercice Phase 2 : Connexion PostgreSQL et SQLAlchemy

## 📝 Exercice à réaliser

Créez un script Python qui :

1. Se connecte à PostgreSQL avec SQLAlchemy
2. Crée une table simple `products`
3. Insère quelques produits
4. Récupère et affiche les produits
5. Met à jour un produit
6. Supprime un produit

## 🎯 Objectifs pédagogiques

- Comprendre la connexion SQLAlchemy à PostgreSQL
- Maîtriser la création de tables
- Apprendre les opérations CRUD de base
- Gérer les sessions SQLAlchemy

## 💻 Code à écrire

Créez un fichier `exercice_phase2.py` et implémentez toutes les opérations.

**Structure attendue :**
- Configuration de la connexion
- Définition du modèle Product
- Fonctions pour CRUD
- Script principal qui exécute toutes les opérations

## ✅ Correction complète

```python
"""
Exercice Phase 2 : Connexion PostgreSQL et SQLAlchemy
Ce script démontre les opérations CRUD de base avec SQLAlchemy
"""

from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError
import os
from dotenv import load_dotenv

# Charger les variables d'environnement
load_dotenv()

# ============================================
# 1. CONFIGURATION DE LA CONNEXION
# ============================================

# Récupérer l'URL de connexion depuis les variables d'environnement
# Format: postgresql://user:password@host:port/database
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:password@localhost:5432/test_db"
)

# Créer l'engine (point de connexion à la base de données)
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # Vérifie la connexion avant utilisation
    echo=True  # Affiche les requêtes SQL (utile pour le debug)
)

# Créer la session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base pour les modèles
Base = declarative_base()


# ============================================
# 2. DÉFINITION DU MODÈLE
# ============================================

class Product(Base):
    """
    Modèle SQLAlchemy représentant la table 'products'.
    
    Attributs:
        id: Identifiant unique (clé primaire)
        name: Nom du produit
        price: Prix du produit
        description: Description optionnelle
    """
    __tablename__ = "products"
    
    # Colonnes de la table
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, index=True)
    price = Column(Float, nullable=False)
    description = Column(String(500), nullable=True)
    
    def __repr__(self):
        """Représentation string de l'objet (utile pour le debug)"""
        return f"<Product(id={self.id}, name='{self.name}', price={self.price})>"


# ============================================
# 3. CRÉATION DE LA TABLE
# ============================================

def create_tables():
    """
    Crée toutes les tables définies dans les modèles.
    
    Note: En production, utilisez Alembic pour les migrations.
    """
    print("🔄 Création des tables...")
    Base.metadata.create_all(bind=engine)
    print("✅ Tables créées avec succès!")


# ============================================
# 4. OPÉRATIONS CRUD
# ============================================

def create_product(session, name: str, price: float, description: str = None):
    """
    Crée un nouveau produit dans la base de données.
    
    Args:
        session: Session SQLAlchemy
        name: Nom du produit
        price: Prix du produit
        description: Description optionnelle
        
    Returns:
        Product: Le produit créé
    """
    try:
        # Créer une nouvelle instance du modèle
        new_product = Product(
            name=name,
            price=price,
            description=description
        )
        
        # Ajouter à la session
        session.add(new_product)
        
        # Committer la transaction
        session.commit()
        
        # Rafraîchir pour obtenir l'ID généré
        session.refresh(new_product)
        
        print(f"✅ Produit créé: {new_product}")
        return new_product
        
    except SQLAlchemyError as e:
        # En cas d'erreur, annuler la transaction
        session.rollback()
        print(f"❌ Erreur lors de la création: {e}")
        raise


def get_all_products(session):
    """
    Récupère tous les produits de la base de données.
    
    Args:
        session: Session SQLAlchemy
        
    Returns:
        list: Liste de tous les produits
    """
    try:
        # Requête pour récupérer tous les produits
        products = session.query(Product).all()
        
        print(f"✅ {len(products)} produit(s) trouvé(s)")
        return products
        
    except SQLAlchemyError as e:
        print(f"❌ Erreur lors de la récupération: {e}")
        raise


def get_product_by_id(session, product_id: int):
    """
    Récupère un produit par son ID.
    
    Args:
        session: Session SQLAlchemy
        product_id: ID du produit à récupérer
        
    Returns:
        Product: Le produit trouvé, ou None si inexistant
    """
    try:
        # Requête avec filtre
        product = session.query(Product).filter(Product.id == product_id).first()
        
        if product:
            print(f"✅ Produit trouvé: {product}")
        else:
            print(f"⚠️ Aucun produit avec l'ID {product_id}")
        
        return product
        
    except SQLAlchemyError as e:
        print(f"❌ Erreur lors de la récupération: {e}")
        raise


def update_product(session, product_id: int, name: str = None, price: float = None, description: str = None):
    """
    Met à jour un produit existant.
    
    Args:
        session: Session SQLAlchemy
        product_id: ID du produit à mettre à jour
        name: Nouveau nom (optionnel)
        price: Nouveau prix (optionnel)
        description: Nouvelle description (optionnel)
        
    Returns:
        Product: Le produit mis à jour, ou None si inexistant
    """
    try:
        # Récupérer le produit
        product = session.query(Product).filter(Product.id == product_id).first()
        
        if not product:
            print(f"⚠️ Produit avec l'ID {product_id} non trouvé")
            return None
        
        # Mettre à jour uniquement les champs fournis
        if name is not None:
            product.name = name
        if price is not None:
            product.price = price
        if description is not None:
            product.description = description
        
        # Committer les changements
        session.commit()
        session.refresh(product)
        
        print(f"✅ Produit mis à jour: {product}")
        return product
        
    except SQLAlchemyError as e:
        session.rollback()
        print(f"❌ Erreur lors de la mise à jour: {e}")
        raise


def delete_product(session, product_id: int):
    """
    Supprime un produit de la base de données.
    
    Args:
        session: Session SQLAlchemy
        product_id: ID du produit à supprimer
        
    Returns:
        bool: True si supprimé, False si non trouvé
    """
    try:
        # Récupérer le produit
        product = session.query(Product).filter(Product.id == product_id).first()
        
        if not product:
            print(f"⚠️ Produit avec l'ID {product_id} non trouvé")
            return False
        
        # Supprimer le produit
        session.delete(product)
        session.commit()
        
        print(f"✅ Produit {product_id} supprimé")
        return True
        
    except SQLAlchemyError as e:
        session.rollback()
        print(f"❌ Erreur lors de la suppression: {e}")
        raise


# ============================================
# 5. SCRIPT PRINCIPAL
# ============================================

def main():
    """
    Fonction principale qui exécute toutes les opérations CRUD.
    """
    print("=" * 50)
    print("EXERCICE PHASE 2 : SQLAlchemy et PostgreSQL")
    print("=" * 50)
    
    # Créer les tables
    create_tables()
    
    # Créer une session
    db = SessionLocal()
    
    try:
        print("\n" + "=" * 50)
        print("1. CRÉATION DE PRODUITS")
        print("=" * 50)
        
        # Créer plusieurs produits
        product1 = create_product(
            db,
            name="Laptop",
            price=999.99,
            description="Ordinateur portable haute performance"
        )
        
        product2 = create_product(
            db,
            name="Souris",
            price=29.99,
            description="Souris sans fil"
        )
        
        product3 = create_product(
            db,
            name="Clavier",
            price=79.99
        )
        
        print("\n" + "=" * 50)
        print("2. RÉCUPÉRATION DE TOUS LES PRODUITS")
        print("=" * 50)
        
        # Récupérer tous les produits
        all_products = get_all_products(db)
        for product in all_products:
            print(f"  - {product}")
        
        print("\n" + "=" * 50)
        print("3. RÉCUPÉRATION PAR ID")
        print("=" * 50)
        
        # Récupérer un produit par ID
        found_product = get_product_by_id(db, product1.id)
        
        print("\n" + "=" * 50)
        print("4. MISE À JOUR D'UN PRODUIT")
        print("=" * 50)
        
        # Mettre à jour le prix du premier produit
        updated_product = update_product(
            db,
            product_id=product1.id,
            price=899.99
        )
        
        print("\n" + "=" * 50)
        print("5. SUPPRESSION D'UN PRODUIT")
        print("=" * 50)
        
        # Supprimer le troisième produit
        delete_product(db, product3.id)
        
        print("\n" + "=" * 50)
        print("6. VÉRIFICATION FINALE")
        print("=" * 50)
        
        # Vérifier les produits restants
        remaining_products = get_all_products(db)
        print(f"\n📊 Produits restants: {len(remaining_products)}")
        for product in remaining_products:
            print(f"  - {product}")
        
    except Exception as e:
        print(f"\n❌ Erreur générale: {e}")
        
    finally:
        # Toujours fermer la session
        db.close()
        print("\n✅ Session fermée")


if __name__ == "__main__":
    main()
```

## 📚 Explications détaillées

### 1. Configuration de la connexion

```python
DATABASE_URL = "postgresql://user:password@host:port/database"
engine = create_engine(DATABASE_URL, pool_pre_ping=True, echo=True)
```

**Explication :**
- **Connection String** : Format standard pour se connecter à PostgreSQL
- **pool_pre_ping=True** : Vérifie la connexion avant utilisation (évite les erreurs de timeout)
- **echo=True** : Affiche les requêtes SQL dans la console (utile pour apprendre)

### 2. Session SQLAlchemy

```python
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()
```

**Explication :**
- **sessionmaker** : Factory pour créer des sessions
- **autocommit=False** : Les changements ne sont pas automatiquement commités
- **autoflush=False** : Les requêtes ne sont pas automatiquement exécutées
- **bind=engine** : Lie la session à l'engine spécifique

### 3. Définition du modèle

```python
class Product(Base):
    __tablename__ = "products"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, index=True)
```

**Explication :**
- **Base** : Classe de base pour tous les modèles
- **__tablename__** : Nom de la table dans PostgreSQL
- **primary_key=True** : Clé primaire (unique, auto-incrémentée)
- **index=True** : Crée un index pour accélérer les recherches
- **nullable=False** : Le champ est obligatoire

### 4. Création de tables

```python
Base.metadata.create_all(bind=engine)
```

**Explication :**
- **metadata** : Contient toutes les informations sur les tables
- **create_all()** : Crée toutes les tables définies dans les modèles
- ⚠️ **Note** : En production, utilisez Alembic pour les migrations

### 5. Opération CREATE

```python
new_product = Product(name="Laptop", price=999.99)
session.add(new_product)
session.commit()
session.refresh(new_product)
```

**Explication :**
- **add()** : Ajoute l'objet à la session (pas encore en base)
- **commit()** : Enregistre les changements dans la base de données
- **refresh()** : Recharge l'objet depuis la base (pour obtenir l'ID généré)

### 6. Opération READ

```python
# Tous les produits
products = session.query(Product).all()

# Un produit par ID
product = session.query(Product).filter(Product.id == product_id).first()
```

**Explication :**
- **query()** : Démarre une requête
- **all()** : Récupère tous les résultats
- **filter()** : Ajoute une condition WHERE
- **first()** : Récupère le premier résultat (ou None)

### 7. Opération UPDATE

```python
product = session.query(Product).filter(Product.id == product_id).first()
product.price = 899.99
session.commit()
```

**Explication :**
- Modifier l'objet Python modifie automatiquement la base au commit
- SQLAlchemy suit les changements (tracking)
- **commit()** : Enregistre les modifications

### 8. Opération DELETE

```python
product = session.query(Product).filter(Product.id == product_id).first()
session.delete(product)
session.commit()
```

**Explication :**
- **delete()** : Marque l'objet pour suppression
- **commit()** : Exécute la suppression en base

### 9. Gestion des erreurs

```python
try:
    # Opération
    session.commit()
except SQLAlchemyError as e:
    session.rollback()
    raise
```

**Explication :**
- **try/except** : Capture les erreurs SQLAlchemy
- **rollback()** : Annule la transaction en cas d'erreur
- Important pour maintenir la cohérence de la base

## 🧪 Comment tester

### 1. Préparer la base de données

```sql
-- Se connecter à PostgreSQL
psql -U postgres

-- Créer la base de données de test
CREATE DATABASE test_db;
```

### 2. Configurer .env

Créez un fichier `.env` :
```
DATABASE_URL=postgresql://postgres:password@localhost:5432/test_db
```

### 3. Exécuter le script

```bash
python exercice_phase2.py
```

### 4. Vérifier dans PostgreSQL

```sql
-- Se connecter à la base
\c test_db

-- Voir les tables
\dt

-- Voir les données
SELECT * FROM products;
```

## 🎓 Points clés à retenir

1. **Engine** : Point de connexion unique à la base
2. **Session** : Contexte de transaction (une par requête)
3. **Modèles** : Classes Python représentant les tables
4. **Commit** : Nécessaire pour enregistrer les changements
5. **Rollback** : Important en cas d'erreur
6. **Query API** : Méthode Pythonique pour interroger la base

## 🐛 Erreurs courantes

### Erreur : "relation does not exist"
**Cause :** La table n'existe pas encore
**Solution :** Exécutez `create_tables()` avant les opérations

### Erreur : "connection refused"
**Cause :** PostgreSQL n'est pas démarré ou URL incorrecte
**Solution :** Vérifiez que PostgreSQL tourne et l'URL de connexion

### Erreur : "uncommitted changes"
**Cause :** Tentative de nouvelle requête sans commit
**Solution :** Faites `commit()` ou `rollback()` avant

## ✅ Checklist de validation

- [ ] La connexion à PostgreSQL fonctionne
- [ ] Les tables sont créées
- [ ] Vous pouvez créer des produits
- [ ] Vous pouvez récupérer tous les produits
- [ ] Vous pouvez récupérer un produit par ID
- [ ] Vous pouvez mettre à jour un produit
- [ ] Vous pouvez supprimer un produit
- [ ] Les erreurs sont gérées avec try/except
- [ ] La session est toujours fermée (finally)

---

**Excellent travail ! Vous maîtrisez maintenant SQLAlchemy ! 🎉**

