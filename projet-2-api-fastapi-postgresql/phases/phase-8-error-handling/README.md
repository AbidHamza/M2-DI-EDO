# Phase 8 : Gestion des erreurs et validation

## 🎯 Objectif de la phase

Améliorer la gestion des erreurs avec des exceptions personnalisées et des handlers globaux.

## 📋 Tâches du projet

### Étape 1 : Créer les exceptions personnalisées

Créez `app/exceptions.py` :

```python
class NotFoundError(HTTPException):
    def __init__(self, resource: str):
        super().__init__(status_code=404, detail=f"{resource} not found")
```

### Étape 2 : Créer le handler global

Dans `app/main.py` :

```python
@app.exception_handler(NotFoundError)
async def not_found_handler(request, exc):
    return JSONResponse(status_code=404, content={"detail": exc.detail})
```

## ✅ Livrable de la phase

- [ ] Exceptions personnalisées créées
- [ ] Handler global configuré
- [ ] Messages d'erreur clairs

## ➡️ Prochaine phase

Passez à la **Phase 9 : Tests unitaires et d'intégration**.

