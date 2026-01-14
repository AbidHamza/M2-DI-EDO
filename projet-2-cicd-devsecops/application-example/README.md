# Application Exemple - API REST Python

## Description

Cette application est fournie comme exemple pour être déployée via la chaîne CI/CD. Vous pouvez l'utiliser telle quelle ou développer votre propre application.

## Technologies

- Python 3.10+
- FastAPI (framework web moderne)
- Pydantic (validation)
- SQLite (base de données simple)

## Structure

```
application-example/
├── README.md
├── main.py              # Application FastAPI principale
├── models.py            # Modèles de données
├── requirements.txt     # Dépendances Python
├── Dockerfile          # Image Docker
├── tests/              # Tests unitaires
│   └── test_api.py
└── .sonar-project.properties  # Configuration SonarQube
```

## Installation et utilisation

### Local

```bash
# Installer les dépendances
pip install -r requirements.txt

# Démarrer l'application
uvicorn main:app --reload
```

### Docker

```bash
# Construire l'image
docker build -t example-api .

# Démarrer
docker run -p 8000:8000 example-api
```

## Endpoints

- `GET /` : Documentation API
- `GET /api/items` : Liste des items
- `POST /api/items` : Créer un item
- `GET /api/items/{id}` : Récupérer un item
- `PUT /api/items/{id}` : Mettre à jour un item
- `DELETE /api/items/{id}` : Supprimer un item

## Tests

```bash
# Exécuter les tests
pytest tests/
```

## Utilisation avec CI/CD

Cette application est conçue pour être déployée via :
- Tests unitaires (pytest)
- Analyse SonarQube
- Build Docker
- Déploiement automatisé

