# Phase 7 : API pour les prêts de livres

## 🎯 Objectif de la phase

Créer les endpoints pour gérer les prêts de livres avec logique métier (vérifications, règles).

## 📚 Rappels techniques essentiels

### Logique métier
- **Règles métier** : Vérifications spécifiques à l'application
- **Transactions** : Opérations atomiques
- **Relations** : Utiliser les relations SQLAlchemy

## 📋 Tâches du projet

### Étape 1 : Créer les routes Loans

Créez `app/routes/loans.py` :

**Endpoints à créer :**

1. **POST /loans** :
   - Emprunter un livre
   - Vérifier que le livre est disponible
   - Vérifier qu'aucun prêt en cours
   - Calculer due_date (ex: +14 jours)

2. **GET /loans** :
   - Liste les prêts de l'utilisateur connecté
   - Filtrer par is_returned

3. **PUT /loans/{id}/return** :
   - Retourner un livre
   - Mettre à jour return_date et is_returned
   - Remettre le livre disponible

### Étape 2 : Implémenter la logique métier

- Vérifier disponibilité du livre
- Vérifier qu'aucun prêt en cours pour ce livre/utilisateur
- Gérer les dates (loan_date, due_date, return_date)

## ✅ Livrable de la phase

- [ ] Emprunt de livre fonctionne
- [ ] Retour de livre fonctionne
- [ ] Règles métier respectées
- [ ] Gestion des erreurs

## ➡️ Prochaine phase

Passez à la **Phase 8 : Gestion des erreurs et validation**.

