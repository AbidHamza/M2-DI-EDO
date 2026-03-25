# Etape 2 : Application de Demonstration (Flask + Prometheus)

## Objectif

Dans cette etape, nous creons une **application web Flask** instrumentee avec des metriques Prometheus. Cette application servira de cible pour notre stack d'observabilite : Prometheus collectera ses metriques, Loki ses logs, et Grafana les visualisera.

---

## Pourquoi Instrumenter une Application ?

L'observabilite ne fonctionne que si les applications **exposent des donnees exploitables**. Sans instrumentation :
- Prometheus ne peut pas collecter de metriques metier
- Les logs ne sont pas structures, donc difficiles a exploiter dans Loki
- Les dashboards restent vides ou se limitent aux metriques systeme

L'instrumentation, c'est le pont entre votre code et votre stack d'observabilite.

---

## Structure de l'Application

```
app/
|-- app.py              # Application Flask instrumentee
|-- requirements.txt    # Dependances Python
|-- Dockerfile          # Image Docker
```

---

## 1. Application Flask (app.py)

### Les Metriques Exposees

Notre application expose 4 types de metriques Prometheus :

| Metrique | Type | Description |
|----------|------|-------------|
| `flask_http_requests_total` | Counter | Nombre total de requetes HTTP par methode, endpoint et statut |
| `flask_http_request_duration_seconds` | Histogram | Duree des requetes HTTP (distribution en buckets) |
| `flask_active_requests` | Gauge | Nombre de requetes en cours de traitement |
| `flask_app_info` | Gauge | Informations sur l'application (version) |

### Les Endpoints

| Endpoint | Description | Usage |
|----------|-------------|-------|
| `GET /` | Page d'accueil avec liens | Navigation |
| `GET /health` | Health check (renvoie `{"status": "healthy"}`) | Verification de sante |
| `GET /metrics` | Metriques Prometheus au format texte | Scraping Prometheus |
| `GET /api/data` | Simule un traitement (latence aleatoire) | Test de charge |
| `GET /api/error` | Simule une erreur 500 | Test d'alertes |

### Comprendre l'Instrumentation

#### Counter : `flask_http_requests_total`

```python
from prometheus_client import Counter

REQUEST_COUNT = Counter(
    'flask_http_requests_total',       # Nom de la metrique
    'Total HTTP requests',              # Description
    ['method', 'endpoint', 'status']    # Labels (dimensions)
)

# A chaque requete, on incremente :
REQUEST_COUNT.labels(
    method='GET',
    endpoint='/api/data',
    status='200'
).inc()
```

Un Counter ne fait **que monter**. Pour obtenir le taux par seconde, on utilise `rate()` dans PromQL :
```promql
rate(flask_http_requests_total[5m])
```

#### Histogram : `flask_http_request_duration_seconds`

```python
from prometheus_client import Histogram

REQUEST_LATENCY = Histogram(
    'flask_http_request_duration_seconds',
    'HTTP request latency in seconds',
    ['method', 'endpoint'],
    buckets=[0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0]
)

# On mesure le temps d'execution :
with REQUEST_LATENCY.labels(method='GET', endpoint='/api/data').time():
    # ... traitement de la requete ...
    pass
```

Un Histogram repartit les valeurs dans des **buckets**. Cela permet de calculer les percentiles :
```promql
histogram_quantile(0.95, rate(flask_http_request_duration_seconds_bucket[5m]))
```

#### Gauge : `flask_active_requests`

```python
from prometheus_client import Gauge

ACTIVE_REQUESTS = Gauge(
    'flask_active_requests',
    'Number of active requests being processed'
)

# Avant le traitement :
ACTIVE_REQUESTS.inc()    # +1

# Apres le traitement :
ACTIVE_REQUESTS.dec()    # -1
```

Un Gauge peut monter et descendre. Il represente une valeur instantanee.

### Logs Structures (JSON)

Pour que Loki puisse exploiter efficacement nos logs, nous utilisons le format **JSON structure** :

```python
import logging
from pythonjsonlogger import jsonlogger

# Configuration du logger JSON
handler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    '%(asctime)s %(name)s %(levelname)s %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S'
)
handler.setFormatter(formatter)
logger = logging.getLogger()
logger.addHandler(handler)
```

**Pourquoi JSON ?**
- Loki peut **parser les champs** automatiquement
- Les requetes LogQL deviennent plus puissantes :
  ```logql
  {job="flask-app"} | json | levelname="ERROR"
  ```
- Les logs sont **lisibles par les machines** tout en restant comprehensibles

---

## 2. Dependances (requirements.txt)

```
Flask==3.0.3
prometheus_client==0.21.0
python-json-logger==2.0.7
gunicorn==22.0.0
```

| Paquet | Role |
|--------|------|
| **Flask** | Framework web leger |
| **prometheus_client** | Bibliotheque officielle Prometheus pour Python |
| **python-json-logger** | Formateur de logs JSON pour le module logging |
| **gunicorn** | Serveur WSGI production-ready (remplace le serveur de dev Flask) |

---

## 3. Dockerfile

Notre Dockerfile utilise un **build multi-stage** pour optimiser la taille de l'image et suit les bonnes pratiques de securite :

### Bonnes Pratiques Appliquees

1. **Image de base legere** : `python:3.11-slim` (~120 Mo vs ~900 Mo pour `python:3.11`)
2. **Utilisateur non-root** : l'application tourne sous un utilisateur `appuser`
3. **Cache des dependances** : `requirements.txt` copie avant le code (layer caching)
4. **HEALTHCHECK** : Docker peut verifier la sante du conteneur
5. **Variables d'environnement** : `PYTHONUNBUFFERED=1` pour voir les logs en temps reel

---

## 4. Test Local

### Sans Docker

```bash
cd app/
pip install -r requirements.txt
python app.py
```

Puis visitez :
- http://localhost:5000 — Page d'accueil
- http://localhost:5000/metrics — Metriques Prometheus
- http://localhost:5000/health — Health check
- http://localhost:5000/api/data — Endpoint de donnees

### Avec Docker

```bash
cd app/
docker build -t flask-observability-app .
docker run -p 5000:5000 flask-observability-app
```

### Verifier les Metriques

Accedez a http://localhost:5000/metrics et vous devriez voir :

```
# HELP flask_http_requests_total Total HTTP requests
# TYPE flask_http_requests_total counter
flask_http_requests_total{endpoint="/",method="GET",status="200"} 1.0

# HELP flask_http_request_duration_seconds HTTP request latency in seconds
# TYPE flask_http_request_duration_seconds histogram
flask_http_request_duration_seconds_bucket{endpoint="/",method="GET",le="0.01"} 1.0
...

# HELP flask_active_requests Number of active requests being processed
# TYPE flask_active_requests gauge
flask_active_requests 0.0
```

---

## 5. Points Cles pour le Rapport

- Expliquez **pourquoi** vous avez choisi ces metriques (RED method : Rate, Errors, Duration)
- Montrez la **difference entre Counter, Histogram et Gauge** avec des exemples
- Expliquez l'interet des **logs structures** pour Loki
- Justifiez les choix du **Dockerfile** (multi-stage, non-root, healthcheck)
- Incluez des **captures d'ecran** de l'endpoint `/metrics`
