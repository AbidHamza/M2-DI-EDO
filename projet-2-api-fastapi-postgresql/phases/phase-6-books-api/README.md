# Phase 6 : API CRUD pour les livres

## 🎯 Objectif de la phase

Créer les endpoints complets pour gérer les livres : création, lecture, mise à jour, suppression, avec pagination et filtrage.

## 📚 Rappels techniques essentiels

### CRUD Operations
- **Create** : POST - Créer une ressource
- **Read** : GET - Lire une ou plusieurs ressources
- **Update** : PUT/PATCH - Mettre à jour
- **Delete** : DELETE - Supprimer

### Pagination
- **skip/limit** : Pagination basique
- **page/page_size** : Pagination par page
- **Query Parameters** : Paramètres dans l'URL

### Filtrage
- **Query Parameters** : Filtres dans l'URL
- **SQLAlchemy filter()** : Conditions WHERE
- **ilike** : Recherche insensible à la casse

## 🏋️ Exercice pratique : API CRUD complète

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

## 📋 Tâches du projet

### Étape 1 : Créer les routes Books

Créez `app/routes/books.py` :

**Endpoints à créer :**

1. **POST /books** (protégé) :
   - Crée un nouveau livre
   - Valide avec BookCreate
   - Retourne BookResponse

2. **GET /books** :
   - Liste tous les livres
   - Pagination (skip, limit)
   - Filtrage (title, author, is_available)

3. **GET /books/{id}** :
   - Récupère un livre par ID
   - Retourne 404 si non trouvé

4. **PUT /books/{id}** (protégé) :
   - Met à jour un livre
   - Mise à jour partielle avec BookUpdate

5. **DELETE /books/{id}** (protégé) :
   - Supprime un livre
   - Retourne 204 si succès

### Étape 2 : Implémenter la pagination

```python
skip: int = Query(0, ge=0)
limit: int = Query(10, ge=1, le=100)
```

### Étape 3 : Implémenter le filtrage

```python
title: Optional[str] = None
author: Optional[str] = None
is_available: Optional[bool] = None
```

### Étape 4 : Protéger les routes de modification

Utilisez `Depends(get_current_user)` pour POST, PUT, DELETE.

## ✅ Livrable de la phase

- [ ] Tous les endpoints CRUD fonctionnent
- [ ] Pagination implémentée
- [ ] Filtrage implémenté
- [ ] Routes protégées fonctionnent
- [ ] Gestion d'erreurs appropriée

## ➡️ Prochaine phase

Passez à la **Phase 7 : API pour les prêts de livres**.

