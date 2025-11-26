# Exercice Phase 4 : Schémas Pydantic avec Validation

## 📝 Exercice à réaliser

Créez un système complet de schémas Pydantic pour une application de gestion de produits avec :

1. **Schéma Product** : Create, Update, Response
2. **Schéma Category** : Create, Response
3. **Validation avancée** : Contraintes, formats, valeurs par défaut
4. **Tests de validation** : Vérifier que les validations fonctionnent

## 🎯 Objectifs pédagogiques

- Comprendre Pydantic BaseModel
- Maîtriser Field() pour les contraintes
- Utiliser l'héritage de schémas
- Valider les données complexes
- Gérer les types optionnels

## ✅ Correction complète

```python
"""
Exercice Phase 4 : Schémas Pydantic avec Validation
Démontre la création de schémas avec validation avancée
"""

from pydantic import BaseModel, Field, EmailStr, validator
from typing import Optional, List
from datetime import datetime
from decimal import Decimal

# ============================================
# 1. SCHÉMA CATEGORY
# ============================================

class CategoryBase(BaseModel):
    """
    Schéma de base pour Category.
    Contient les champs communs à tous les schémas Category.
    """
    name: str = Field(
        ...,
        min_length=2,
        max_length=50,
        description="Nom de la catégorie",
        example="Électronique"
    )
    description: Optional[str] = Field(
        None,
        max_length=500,
        description="Description de la catégorie"
    )


class CategoryCreate(CategoryBase):
    """
    Schéma pour créer une nouvelle catégorie.
    Hérite de CategoryBase (tous les champs sont requis).
    """
    pass  # Pas de champs supplémentaires


class CategoryResponse(CategoryBase):
    """
    Schéma retourné lors de la récupération d'une catégorie.
    Inclut les champs de base + les champs générés (id, dates).
    """
    id: int
    created_at: datetime
    
    class Config:
        """
        Configuration Pydantic.
        from_attributes permet de créer le schéma depuis un objet SQLAlchemy.
        """
        from_attributes = True


# ============================================
# 2. SCHÉMA PRODUCT
# ============================================

class ProductBase(BaseModel):
    """
    Schéma de base pour Product.
    """
    name: str = Field(
        ...,
        min_length=1,
        max_length=200,
        description="Nom du produit",
        example="Laptop HP"
    )
    description: Optional[str] = Field(
        None,
        max_length=2000,
        description="Description détaillée du produit"
    )
    price: Decimal = Field(
        ...,
        gt=0,  # Greater than 0 (strictement supérieur à 0)
        description="Prix du produit",
        example=999.99
    )
    stock: int = Field(
        ...,
        ge=0,  # Greater or equal to 0 (supérieur ou égal à 0)
        description="Quantité en stock",
        example=10
    )
    sku: Optional[str] = Field(
        None,
        min_length=3,
        max_length=50,
        description="Code SKU du produit",
        example="LAP-HP-001"
    )


class ProductCreate(ProductBase):
    """
    Schéma pour créer un nouveau produit.
    Ajoute le category_id qui n'est pas dans ProductBase.
    """
    category_id: int = Field(
        ...,
        gt=0,
        description="ID de la catégorie",
        example=1
    )


class ProductUpdate(BaseModel):
    """
    Schéma pour mettre à jour un produit.
    Tous les champs sont optionnels (mise à jour partielle).
    """
    name: Optional[str] = Field(
        None,
        min_length=1,
        max_length=200
    )
    description: Optional[str] = Field(
        None,
        max_length=2000
    )
    price: Optional[Decimal] = Field(
        None,
        gt=0
    )
    stock: Optional[int] = Field(
        None,
        ge=0
    )
    sku: Optional[str] = Field(
        None,
        min_length=3,
        max_length=50
    )
    category_id: Optional[int] = Field(
        None,
        gt=0
    )


class ProductResponse(ProductBase):
    """
    Schéma retourné lors de la récupération d'un produit.
    Inclut les champs de base + id, dates, et relation avec Category.
    """
    id: int
    category_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    # Relation avec Category (optionnel, peut être chargé ou non)
    category: Optional[CategoryResponse] = None
    
    class Config:
        from_attributes = True


# ============================================
# 3. SCHÉMA AVANCÉ : PRODUCT WITH CATEGORY
# ============================================

class ProductWithCategory(ProductResponse):
    """
    Schéma étendu qui inclut toujours la catégorie.
    Utile pour les endpoints qui retournent toujours la catégorie.
    """
    category: CategoryResponse  # Non optionnel ici


# ============================================
# 4. VALIDATION PERSONNALISÉE
# ============================================

class ProductWithCustomValidation(ProductBase):
    """
    Exemple de schéma avec validation personnalisée.
    """
    
    @validator('sku')
    def validate_sku(cls, v):
        """
        Validateur personnalisé pour SKU.
        Vérifie que le SKU commence par une lettre majuscule.
        
        Args:
            v: Valeur du champ sku
            
        Returns:
            str: SKU validé
            
        Raises:
            ValueError: Si le SKU ne respecte pas le format
        """
        if v and not v[0].isupper():
            raise ValueError('SKU doit commencer par une majuscule')
        return v
    
    @validator('name')
    def validate_name(cls, v):
        """
        Validateur pour le nom.
        Supprime les espaces en début/fin.
        """
        return v.strip() if v else v


# ============================================
# 5. SCHÉMA POUR LISTE
# ============================================

class ProductListResponse(BaseModel):
    """
    Schéma pour retourner une liste de produits avec pagination.
    """
    items: List[ProductResponse]
    total: int
    page: int
    page_size: int
    total_pages: int


# ============================================
# 6. TESTS DE VALIDATION
# ============================================

def test_validations():
    """
    Teste toutes les validations des schémas.
    """
    print("=" * 60)
    print("TESTS DE VALIDATION")
    print("=" * 60)
    
    # ========================================
    # Test 1 : Schéma valide
    # ========================================
    print("\n1️⃣ Test : Schéma valide")
    try:
        product = ProductCreate(
            name="Laptop HP",
            price=999.99,
            stock=10,
            sku="LAP-HP-001",
            category_id=1
        )
        print(f"✅ Produit valide créé: {product.name}")
    except Exception as e:
        print(f"❌ Erreur inattendue: {e}")
    
    # ========================================
    # Test 2 : Nom trop court
    # ========================================
    print("\n2️⃣ Test : Nom trop court (devrait échouer)")
    try:
        product = ProductCreate(
            name="",  # Trop court
            price=999.99,
            stock=10,
            category_id=1
        )
        print("❌ La validation aurait dû échouer!")
    except Exception as e:
        print(f"✅ Validation fonctionne: {e.errors()[0]['msg']}")
    
    # ========================================
    # Test 3 : Prix négatif
    # ========================================
    print("\n3️⃣ Test : Prix négatif (devrait échouer)")
    try:
        product = ProductCreate(
            name="Laptop",
            price=-10,  # Négatif
            stock=10,
            category_id=1
        )
        print("❌ La validation aurait dû échouer!")
    except Exception as e:
        print(f"✅ Validation fonctionne: {e.errors()[0]['msg']}")
    
    # ========================================
    # Test 4 : Stock négatif
    # ========================================
    print("\n4️⃣ Test : Stock négatif (devrait échouer)")
    try:
        product = ProductCreate(
            name="Laptop",
            price=999.99,
            stock=-5,  # Négatif
            category_id=1
        )
        print("❌ La validation aurait dû échouer!")
    except Exception as e:
        print(f"✅ Validation fonctionne: {e.errors()[0]['msg']}")
    
    # ========================================
    # Test 5 : Mise à jour partielle
    # ========================================
    print("\n5️⃣ Test : Mise à jour partielle")
    try:
        update = ProductUpdate(
            price=899.99  # Seul le prix est mis à jour
        )
        print(f"✅ Mise à jour partielle valide: prix={update.price}")
    except Exception as e:
        print(f"❌ Erreur: {e}")
    
    # ========================================
    # Test 6 : Validation personnalisée
    # ========================================
    print("\n6️⃣ Test : Validation personnalisée SKU")
    try:
        product = ProductWithCustomValidation(
            name="Laptop",
            price=999.99,
            stock=10,
            sku="lap-001"  # Commence par minuscule
        )
        print("❌ La validation aurait dû échouer!")
    except Exception as e:
        print(f"✅ Validation personnalisée fonctionne: {e.errors()[0]['msg']}")
    
    # ========================================
    # Test 7 : Schéma Response
    # ========================================
    print("\n7️⃣ Test : Schéma Response")
    try:
        # Simule un objet SQLAlchemy
        class MockProduct:
            id = 1
            name = "Laptop"
            price = Decimal("999.99")
            stock = 10
            category_id = 1
            created_at = datetime.now()
            updated_at = None
        
        # Créer le schéma depuis l'objet
        response = ProductResponse.from_orm(MockProduct())
        print(f"✅ Schéma Response créé: {response.name} (ID: {response.id})")
    except Exception as e:
        print(f"❌ Erreur: {e}")
    
    print("\n" + "=" * 60)
    print("✅ TOUS LES TESTS TERMINÉS")
    print("=" * 60)


# ============================================
# 7. EXEMPLE D'UTILISATION DANS FASTAPI
# ============================================

def example_fastapi_usage():
    """
    Exemple d'utilisation des schémas dans FastAPI.
    (Code commenté pour référence)
    """
    example_code = '''
from fastapi import FastAPI, HTTPException
from app.schemas.product import ProductCreate, ProductResponse, ProductUpdate

app = FastAPI()

@app.post("/products", response_model=ProductResponse, status_code=201)
def create_product(product: ProductCreate):
    """
    Crée un nouveau produit.
    FastAPI valide automatiquement product selon ProductCreate.
    """
    # product est déjà validé par FastAPI
    # Créer le produit en base de données
    # ...
    return created_product

@app.get("/products/{id}", response_model=ProductResponse)
def get_product(id: int):
    """
    Récupère un produit par ID.
    FastAPI sérialise automatiquement selon ProductResponse.
    """
    # Récupérer depuis la base
    # ...
    return product

@app.put("/products/{id}", response_model=ProductResponse)
def update_product(id: int, product_update: ProductUpdate):
    """
    Met à jour un produit.
    Tous les champs de product_update sont optionnels.
    """
    # Mettre à jour uniquement les champs fournis
    # ...
    return updated_product
    '''
    print("\n" + "=" * 60)
    print("EXEMPLE D'UTILISATION DANS FASTAPI")
    print("=" * 60)
    print(example_code)


if __name__ == "__main__":
    # Exécuter les tests
    test_validations()
    
    # Afficher l'exemple FastAPI
    example_fastapi_usage()
```

## 📚 Explications détaillées

### 1. Héritage de schémas

```python
class ProductBase(BaseModel):
    name: str
    price: Decimal

class ProductCreate(ProductBase):
    category_id: int
```

**Explication :**
- **ProductBase** : Contient les champs communs
- **ProductCreate** : Hérite de ProductBase + ajoute category_id
- **Avantage** : Évite la duplication de code

### 2. Field() pour les contraintes

```python
price: Decimal = Field(..., gt=0, description="Prix du produit")
```

**Explication :**
- **...** : Champ obligatoire
- **gt=0** : Greater than 0 (strictement supérieur)
- **ge=0** : Greater or equal (supérieur ou égal)
- **lt, le** : Less than, Less or equal
- **description** : Documentation pour Swagger

### 3. Types optionnels

```python
description: Optional[str] = Field(None, max_length=500)
```

**Explication :**
- **Optional[str]** : Peut être str ou None
- **Field(None, ...)** : Valeur par défaut None
- **max_length** : Longueur maximale

### 4. Validation personnalisée

```python
@validator('sku')
def validate_sku(cls, v):
    if v and not v[0].isupper():
        raise ValueError('SKU doit commencer par une majuscule')
    return v
```

**Explication :**
- **@validator** : Décorateur pour validation personnalisée
- **cls** : Classe (pas self, c'est une méthode de classe)
- **v** : Valeur à valider
- **raise ValueError** : Lève une erreur si invalide

### 5. from_attributes (anciennement from_orm)

```python
class Config:
    from_attributes = True
```

**Explication :**
- Permet de créer le schéma depuis un objet Python (ex: modèle SQLAlchemy)
- **Ancien nom** : `orm_mode = True` (Pydantic v1)
- **Nouveau nom** : `from_attributes = True` (Pydantic v2)

## 🧪 Comment tester

1. **Exécutez le script :**
   ```bash
   python exercice_phase4.py
   ```

2. **Testez dans FastAPI :**
   - Créez une route avec les schémas
   - Testez avec Swagger UI
   - Envoyez des données invalides

## 🎓 Points clés à retenir

1. **Héritage** : Réutilisez les schémas de base
2. **Field()** : Ajoutez des contraintes et documentation
3. **Optional** : Pour les champs optionnels
4. **@validator** : Pour validation personnalisée
5. **from_attributes** : Pour convertir depuis objets Python

## 🐛 Erreurs courantes

- **"field required"** : Champ obligatoire manquant
- **"value is not a valid..."** : Type incorrect
- **"ensure this value is greater than..."** : Contrainte non respectée

## ✅ Checklist de validation

- [ ] Tous les schémas sont créés
- [ ] Les validations fonctionnent (testez avec données invalides)
- [ ] Les contraintes Field() sont appliquées
- [ ] Les schémas Response ont `from_attributes = True`
- [ ] Les schémas Update ont tous les champs optionnels

---

**Excellent ! Vous maîtrisez maintenant Pydantic ! 🎉**

