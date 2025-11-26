# Phase 9 : Tests unitaires et d'intégration

## 🎯 Objectif de la phase

Écrire des tests complets pour valider le fonctionnement de l'API.

## 📋 Tâches du projet

### Étape 1 : Configurer pytest

Créez `tests/conftest.py` :

```python
@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def db():
    # Base de données de test
    ...
```

### Étape 2 : Écrire les tests

- `tests/test_auth.py` : Tests d'authentification
- `tests/test_books.py` : Tests CRUD livres
- `tests/test_loans.py` : Tests prêts

## ✅ Livrable de la phase

- [ ] Tests d'authentification
- [ ] Tests CRUD complets
- [ ] Tests de logique métier
- [ ] Couverture > 80%

## ➡️ Prochaine phase

Passez à la **Phase 10 : Documentation et déploiement**.

