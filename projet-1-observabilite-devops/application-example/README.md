# Application Exemple - API Python Simple

## Description

Cette application est fournie comme exemple pour être supervisée avec Prometheus, Grafana et Loki. Vous pouvez l'utiliser telle quelle ou développer votre propre application.

## Technologies

- Python 3.10+
- Flask (framework web)
- Prometheus Client (exposition de métriques)
- Gunicorn (serveur WSGI)

## Structure

```
application-example/
├── README.md
├── app.py                 # Application Flask principale
├── requirements.txt       # Dépendances Python
├── Dockerfile            # Image Docker
└── docker-compose.yml   # Déploiement avec Docker Compose
```

## Installation et utilisation

### Option 1 : Local

```bash
# Installer les dépendances
pip install -r requirements.txt

# Démarrer l'application
python app.py
```

### Option 2 : Docker

```bash
# Construire l'image
docker build -t example-app .

# Démarrer avec docker-compose
docker-compose up -d
```

## Endpoints

- `GET /` : Page d'accueil
- `GET /health` : Health check
- `GET /api/data` : Endpoint API avec métriques
- `GET /metrics` : Métriques Prometheus

## Métriques exposées

- `http_requests_total` : Nombre total de requêtes
- `http_request_duration_seconds` : Durée des requêtes
- `app_errors_total` : Nombre d'erreurs

## Logs générés

L'application génère des logs au format JSON avec différents niveaux (INFO, WARNING, ERROR).

## Utilisation avec Prometheus

L'application expose ses métriques sur `/metrics`. Configurez Prometheus pour scraper ce endpoint.

## Utilisation avec Loki

Les logs sont envoyés vers stdout/stderr. Configurez Promtail pour les collecter et les envoyer à Loki.

