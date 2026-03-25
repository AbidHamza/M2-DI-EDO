# Etape 7 : Monitoring — Prometheus + Grafana

> **Objectif** : Mettre en place un systeme de monitoring complet pour surveiller
> l'application financiere en temps reel avec Prometheus et Grafana.

---

## Table des Matieres

1. [Pourquoi le Monitoring ?](#1-pourquoi-le-monitoring-)
2. [Architecture de Monitoring](#2-architecture-de-monitoring)
3. [Installation avec Docker Compose](#3-installation-avec-docker-compose)
4. [Endpoint /metrics dans l'Application](#4-endpoint-metrics-dans-lapplication)
5. [Configuration Prometheus](#5-configuration-prometheus)
6. [Configuration Grafana](#6-configuration-grafana)
7. [Monitoring de Disponibilite](#7-monitoring-de-disponibilite)
8. [Alerting](#8-alerting)

---

## 1. Pourquoi le Monitoring ?

### Dans un Contexte Financier

Une application financiere doit etre surveillee en permanence :

| Risque | Consequence | Monitoring necessaire |
|---|---|---|
| Application down | Perte de transactions | Uptime monitoring |
| Temps de reponse eleve | Mauvaise experience utilisateur | Latence des requetes |
| Erreurs 500 | Transactions echouees | Taux d'erreur |
| Fuite memoire | Crash progressif | Metriques systeme |
| Attaque DDoS | Surcharge serveur | Requetes par seconde |

### Les 3 Piliers de l'Observabilite

1. **Metriques** (Prometheus) : Donnees numeriques au fil du temps
   - Ex: "85 requetes/seconde", "CPU a 45%"
2. **Logs** (optionnel, Loki/ELK) : Evenements textuels
   - Ex: "2026-03-25 10:00:00 ERROR Transfer failed: insufficient balance"
3. **Traces** (optionnel, Jaeger) : Suivi d'une requete a travers les services
   - Ex: "Requete #42: API → Auth → DB → Response (150ms)"

Dans ce projet, nous nous concentrons sur les **metriques** avec Prometheus + Grafana.

---

## 2. Architecture de Monitoring

```
┌─────────────────────────────────────────────────────────────┐
│                   STACK MONITORING                           │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │  Prometheus  │    │   Grafana    │    │    Node      │  │
│  │    :9090     │    │    :3000     │    │   Exporter   │  │
│  │              │    │              │    │    :9100     │  │
│  │  Collecte    │───→│  Visualise   │    │  Metriques   │  │
│  │  metriques   │    │  dashboards  │    │  systeme     │  │
│  └──────┬───────┘    └──────────────┘    └──────┬───────┘  │
│         │                                       │          │
│         │         Scrape toutes les 15s          │          │
│         ├───────────────────────────────────────┘          │
│         │                                                   │
└─────────┼───────────────────────────────────────────────────┘
          │
          │ Scrape /metrics
          ▼
┌──────────────────┐
│  Finance App     │
│    :5000         │
│                  │
│  GET /metrics    │ → Metriques applicatives
│  GET /health     │ → Status de sante
└──────────────────┘
```

### Flux de Donnees

1. L'application expose ses metriques sur `/metrics` (format Prometheus)
2. **Prometheus** scrape `/metrics` toutes les 15 secondes
3. Prometheus stocke les donnees en time-series
4. **Grafana** interroge Prometheus pour afficher des dashboards
5. **Node Exporter** fournit les metriques systeme (CPU, RAM, disque)

---

## 3. Installation avec Docker Compose

### Demarrer la Stack

```bash
cd monitoring/
docker compose -f docker-compose-monitoring.yml up -d
```

### Services Deployes

| Service | Port | URL | Role |
|---|---|---|---|
| Prometheus | 9090 | http://localhost:9090 | Collecte et stockage |
| Grafana | 3000 | http://localhost:3000 | Visualisation |
| Node Exporter | 9100 | http://localhost:9100/metrics | Metriques systeme |

### Verifier

```bash
# Prometheus
curl http://localhost:9090/-/healthy
# Expected: Prometheus Server is Healthy.

# Grafana
curl http://localhost:3000/api/health
# Expected: {"database":"ok"}

# Node Exporter
curl -s http://localhost:9100/metrics | head -5
```

### Credentials Grafana

- **URL** : http://localhost:3000
- **Login** : `admin`
- **Password** : `admin` (changez-le au premier login)

---

## 4. Endpoint /metrics dans l'Application

### 4.1 Metriques Exposees

Notre application Flask expose les metriques suivantes via la librairie `prometheus_client` :

| Metrique | Type | Description |
|---|---|---|
| `finance_app_requests_total` | Counter | Nombre total de requetes HTTP |
| `finance_app_request_duration_seconds` | Histogram | Duree des requetes |
| `finance_app_transactions_created_total` | Counter | Transactions creees |
| `finance_app_transfer_amount_total` | Counter | Montant total transfere |
| `finance_app_active_accounts` | Gauge | Nombre de comptes actifs |
| `finance_app_errors_total` | Counter | Nombre d'erreurs |

### 4.2 Types de Metriques Prometheus

| Type | Description | Exemple |
|---|---|---|
| **Counter** | Valeur qui ne fait qu'augmenter | Nombre de requetes |
| **Gauge** | Valeur qui peut monter et descendre | Temperature, nombre de connexions |
| **Histogram** | Distribution de valeurs | Duree des requetes (p50, p90, p99) |
| **Summary** | Similaire a Histogram, calcul cote client | Utilisation memoire |

### 4.3 Tester le Endpoint

```bash
# Voir les metriques brutes
curl http://localhost:5000/metrics

# Sortie attendue :
# HELP finance_app_requests_total Total number of HTTP requests
# TYPE finance_app_requests_total counter
finance_app_requests_total{method="GET",endpoint="/health",status="200"} 42.0
finance_app_requests_total{method="POST",endpoint="/api/transfer",status="200"} 15.0
# HELP finance_app_active_accounts Number of active accounts
# TYPE finance_app_active_accounts gauge
finance_app_active_accounts 3.0
```

### 4.4 Endpoint /health

```bash
curl http://localhost:5000/health

{
  "status": "healthy",
  "version": "1.0.0",
  "service": "finance-app",
  "timestamp": "2026-03-25T10:00:00Z"
}
```

---

## 5. Configuration Prometheus

### 5.1 Fichier prometheus.yml

Le fichier `monitoring/prometheus/prometheus.yml` configure :
- L'**intervalle de scrape** (toutes les 15 secondes)
- Les **cibles** a scraper (application + node exporter)

### 5.2 Verifier les Cibles dans Prometheus

1. Ouvrez http://localhost:9090
2. Allez dans **Status > Targets**
3. Vous devez voir :

| Target | State | Labels |
|---|---|---|
| `finance-app:5000` | **UP** | job="finance-app" |
| `node-exporter:9100` | **UP** | job="node-exporter" |

Si un target est **DOWN**, verifiez :
- L'application est-elle demarree ?
- Le port est-il correct ?
- Le conteneur est-il sur le meme reseau Docker ?

### 5.3 Requetes PromQL (Exemples)

| Requete PromQL | Ce qu'elle retourne |
|---|---|
| `finance_app_requests_total` | Nombre total de requetes |
| `rate(finance_app_requests_total[5m])` | Requetes par seconde (moyenne 5min) |
| `finance_app_request_duration_seconds_bucket` | Distribution des durees |
| `histogram_quantile(0.95, rate(finance_app_request_duration_seconds_bucket[5m]))` | P95 latence |
| `finance_app_active_accounts` | Nombre de comptes actifs |
| `up{job="finance-app"}` | 1 si l'app est UP, 0 sinon |

---

## 6. Configuration Grafana

### 6.1 Ajouter Prometheus comme Data Source

1. Ouvrez http://localhost:3000 (admin/admin)
2. **Connections > Data Sources > Add data source**
3. Selectionnez **Prometheus**
4. URL : `http://prometheus:9090` (nom du service Docker)
5. **Save & Test** → "Data source is working"

> Note : Dans notre `docker-compose-monitoring.yml`, Prometheus est provisionne
> automatiquement comme data source.

### 6.2 Importer le Dashboard

1. **Dashboards > Import**
2. Upload le fichier `monitoring/grafana/dashboards/finance-app.json`
3. Selectionnez la data source **Prometheus**
4. **Import**

### 6.3 Panels du Dashboard

Notre dashboard "Finance App - DevSecOps" contient :

| Panel | Type | Metrique |
|---|---|---|
| **Application Status** | Stat | `up{job="finance-app"}` |
| **Requests per Second** | Time series | `rate(finance_app_requests_total[5m])` |
| **Error Rate** | Gauge | Ratio erreurs/total |
| **Active Accounts** | Stat | `finance_app_active_accounts` |
| **Total Transactions** | Stat | `finance_app_transactions_created_total` |
| **Transfer Amount** | Stat | `finance_app_transfer_amount_total` |
| **Request Duration (P95)** | Time series | Percentile 95 de latence |
| **CPU Usage** | Time series | Via Node Exporter |
| **Memory Usage** | Time series | Via Node Exporter |

---

## 7. Monitoring de Disponibilite

### 7.1 Verifier si l'Application est UP

```promql
# 1 = UP, 0 = DOWN
up{job="finance-app"}
```

### 7.2 Calculer l'Uptime

```promql
# Pourcentage de temps UP sur les dernieres 24h
avg_over_time(up{job="finance-app"}[24h]) * 100
```

### 7.3 Objectifs de Disponibilite (SLA)

| SLA | Downtime/an | Downtime/mois |
|---|---|---|
| 99.0% | 3.65 jours | 7.3 heures |
| 99.9% | 8.76 heures | 43.8 minutes |
| 99.99% | 52.56 minutes | 4.38 minutes |

Pour une application financiere, on vise minimum **99.9%**.

---

## 8. Alerting

### 8.1 Regles d'Alerte Prometheus

Les alertes sont definies dans `prometheus.yml` :

```yaml
# Exemples de regles d'alerte
groups:
  - name: finance-app-alerts
    rules:
      - alert: AppDown
        expr: up{job="finance-app"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Finance App is DOWN"

      - alert: HighErrorRate
        expr: rate(finance_app_errors_total[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Error rate exceeds 10%"

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(finance_app_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P95 latency exceeds 1 second"
```

### 8.2 Canaux de Notification

Grafana peut envoyer des alertes via :
- **Email** (SMTP)
- **Slack** (webhook)
- **PagerDuty**
- **Discord**
- **Webhook** generique

### 8.3 Configuration dans Grafana

1. **Alerting > Alert rules > New alert rule**
2. Definir la condition (PromQL)
3. Definir le seuil et la duree
4. Configurer le canal de notification
5. **Save rule**

---

## Fichiers a Examiner

- `monitoring/docker-compose-monitoring.yml` — Stack complète
- `monitoring/prometheus/prometheus.yml` — Configuration Prometheus
- `monitoring/grafana/dashboards/finance-app.json` — Dashboard Grafana
- `app/app.py` — Endpoints `/metrics` et `/health`
