# Etape 2 : Application de Gestion Financiere

> **Objectif** : Creer une application Flask simulant une API de gestion financiere.
> Cette application servira de base pour tout le pipeline CI/CD.

---

## Table des Matieres

1. [Pourquoi une Application Financiere ?](#1-pourquoi-une-application-financiere-)
2. [Architecture de l'Application](#2-architecture-de-lapplication)
3. [Les Endpoints de l'API](#3-les-endpoints-de-lapi)
4. [Mise en Place](#4-mise-en-place)
5. [Tests Unitaires](#5-tests-unitaires)
6. [Docker](#6-docker)

---

## 1. Pourquoi une Application Financiere ?

Le sujet impose un contexte de **gestion financiere**. Cela implique :

- **Donnees sensibles** : montants, soldes, transactions → justifie les scans de securite
- **Integrite des donnees** : un bug sur un calcul de solde = catastrophe → justifie les tests
- **Tracabilite** : chaque transaction doit etre logguee → justifie le monitoring
- **Haute disponibilite** : une appli financiere ne peut pas etre down → justifie le multi-env
- **Conformite** : RGPD, PCI-DSS → justifie les quality gates et les scans

Notre application est **simplifiee** (pas de base de donnees reelle, donnees en memoire),
mais elle simule tous ces enjeux pour le pipeline DevSecOps.

---

## 2. Architecture de l'Application

```
┌─────────────────────────────────────────────────┐
│            APPLICATION FLASK                     │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │          ENDPOINTS API                    │   │
│  │                                          │   │
│  │  GET  /health         → Status + version │   │
│  │  GET  /metrics        → Prometheus       │   │
│  │  GET  /api/transactions → Liste          │   │
│  │  POST /api/transactions → Creer          │   │
│  │  GET  /api/balance      → Solde          │   │
│  │  POST /api/transfer     → Virement       │   │
│  └──────────────────────────────────────────┘   │
│                      │                           │
│                      ▼                           │
│  ┌──────────────────────────────────────────┐   │
│  │        DATA STORE (In-Memory)            │   │
│  │                                          │   │
│  │  accounts = {"ACC001": 1000.0, ...}      │   │
│  │  transactions = [{...}, {...}]           │   │
│  └──────────────────────────────────────────┘   │
│                      │                           │
│                      ▼                           │
│  ┌──────────────────────────────────────────┐   │
│  │        MONITORING                         │   │
│  │                                          │   │
│  │  prometheus_client → /metrics            │   │
│  │  Structured logging (JSON)               │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

---

## 3. Les Endpoints de l'API

### GET /health

Endpoint de verification de sante de l'application.

```bash
curl http://localhost:5000/health
```

Reponse :
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "service": "finance-app",
  "timestamp": "2026-03-25T10:00:00Z"
}
```

**Pourquoi ?** Utilise par :
- Le **healthcheck Docker** pour verifier que le conteneur fonctionne
- **Prometheus** pour le monitoring de disponibilite
- **Ansible** pour valider le deploiement
- Les **load balancers** pour le routage

### GET /metrics

Endpoint Prometheus pour les metriques de l'application.

```bash
curl http://localhost:5000/metrics
```

Reponse (format Prometheus) :
```
# HELP finance_app_requests_total Total requests
# TYPE finance_app_requests_total counter
finance_app_requests_total{method="GET",endpoint="/health"} 42.0
finance_app_transactions_total 15.0
finance_app_balance_total 5000.0
```

### GET /api/transactions

Liste toutes les transactions enregistrees.

```bash
curl http://localhost:5000/api/transactions
```

Reponse :
```json
{
  "transactions": [
    {
      "id": "txn_001",
      "from_account": "ACC001",
      "to_account": "ACC002",
      "amount": 150.00,
      "type": "transfer",
      "timestamp": "2026-03-25T10:00:00Z",
      "status": "completed"
    }
  ],
  "count": 1
}
```

### POST /api/transactions

Cree une nouvelle transaction.

```bash
curl -X POST http://localhost:5000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "from_account": "ACC001",
    "to_account": "ACC002",
    "amount": 100.00,
    "type": "transfer"
  }'
```

Reponse :
```json
{
  "message": "Transaction created successfully",
  "transaction": {
    "id": "txn_abc123",
    "from_account": "ACC001",
    "to_account": "ACC002",
    "amount": 100.00,
    "type": "transfer",
    "timestamp": "2026-03-25T10:05:00Z",
    "status": "completed"
  }
}
```

### GET /api/balance

Retourne le solde d'un compte.

```bash
curl "http://localhost:5000/api/balance?account_id=ACC001"
```

Reponse :
```json
{
  "account_id": "ACC001",
  "balance": 850.00,
  "currency": "EUR",
  "last_updated": "2026-03-25T10:05:00Z"
}
```

### POST /api/transfer

Effectue un virement entre deux comptes.

```bash
curl -X POST http://localhost:5000/api/transfer \
  -H "Content-Type: application/json" \
  -d '{
    "from_account": "ACC001",
    "to_account": "ACC002",
    "amount": 200.00
  }'
```

Reponse (succes) :
```json
{
  "message": "Transfer completed successfully",
  "transfer": {
    "id": "txn_def456",
    "from_account": "ACC001",
    "to_account": "ACC002",
    "amount": 200.00,
    "from_balance": 650.00,
    "to_balance": 1200.00,
    "timestamp": "2026-03-25T10:10:00Z"
  }
}
```

Reponse (solde insuffisant) :
```json
{
  "error": "Insufficient balance",
  "available_balance": 650.00,
  "requested_amount": 5000.00
}
```

---

## 4. Mise en Place

### 4.1 Creer l'environnement Python

```bash
cd app/

# Creer un environnement virtuel
python3 -m venv venv

# Activer l'environnement
source venv/bin/activate       # Linux/Mac
# venv\Scripts\activate        # Windows

# Installer les dependances
pip install -r requirements.txt
```

### 4.2 Lancer l'application

```bash
# Mode developpement
python app.py

# Mode production (avec Gunicorn)
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

### 4.3 Tester les endpoints

```bash
# Health check
curl http://localhost:5000/health

# Creer une transaction
curl -X POST http://localhost:5000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{"from_account": "ACC001", "to_account": "ACC002", "amount": 50}'

# Voir le solde
curl "http://localhost:5000/api/balance?account_id=ACC001"

# Faire un virement
curl -X POST http://localhost:5000/api/transfer \
  -H "Content-Type: application/json" \
  -d '{"from_account": "ACC001", "to_account": "ACC002", "amount": 100}'

# Voir toutes les transactions
curl http://localhost:5000/api/transactions
```

---

## 5. Tests Unitaires

### 5.1 Pourquoi des Tests ?

Dans un contexte financier, les tests sont **obligatoires** :
- **Validite des calculs** : un virement ne doit pas creer d'argent
- **Cas limites** : montant negatif, solde insuffisant, compte inexistant
- **Non-regression** : les nouvelles fonctionnalites ne cassent pas les anciennes
- **Coverage** : SonarQube verifie le taux de couverture (objectif >= 80%)

### 5.2 Lancer les tests

```bash
cd app/

# Tests basiques
pytest tests/ -v

# Tests avec couverture
pytest tests/ -v --cov=. --cov-report=xml --cov-report=term

# Tests avec rapport JUnit (pour GitLab CI)
pytest tests/ -v --junitxml=report.xml
```

### 5.3 Structure des tests

Le fichier `tests/test_app.py` contient :

| Test | Verifie |
|---|---|
| `test_health` | L'endpoint /health retourne 200 et les champs attendus |
| `test_get_transactions` | GET /api/transactions retourne une liste |
| `test_create_transaction` | POST /api/transactions cree bien une transaction |
| `test_get_balance` | GET /api/balance retourne le solde correct |
| `test_transfer` | POST /api/transfer effectue le virement correctement |
| `test_invalid_transfer` | Un montant negatif est rejete (400) |
| `test_insufficient_balance` | Un virement sans fonds est rejete (400) |

---

## 6. Docker

### 6.1 Construire l'image

```bash
cd app/
docker build -t finance-app:latest .
```

### 6.2 Lancer le conteneur

```bash
docker run -d --name finance-app -p 5000:5000 finance-app:latest
```

### 6.3 Verifier

```bash
# Health check
curl http://localhost:5000/health

# Logs
docker logs finance-app
```

### 6.4 Bonnes Pratiques Docker Appliquees

Notre `Dockerfile` suit les bonnes pratiques de securite :

| Pratique | Implementation |
|---|---|
| **Multi-stage build** | Stage build (dependances) + stage runtime (minimal) |
| **Image minimale** | `python:3.11-slim` au lieu de `python:3.11` |
| **Non-root user** | `USER appuser` (pas root dans le conteneur) |
| **Healthcheck** | `HEALTHCHECK CMD curl -f http://localhost:5000/health` |
| **Pas de secrets** | Aucun secret dans l'image, injection par variables |
| **.dockerignore** | Exclut `venv/`, `__pycache__/`, `.git/`, etc. |

---

## Fichiers a Examiner

- `app/app.py` — Code source de l'application
- `app/tests/test_app.py` — Tests unitaires
- `app/requirements.txt` — Dependances Python
- `app/Dockerfile` — Construction de l'image Docker
- `app/.dockerignore` — Exclusions Docker
