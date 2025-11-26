# Exercice Phase 5 : Configuration Prometheus complète

## Exercice à réaliser

Configurez Prometheus pour collecter des métriques depuis l'application exemple et des métriques système.

## Correction complète

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'observability-demo'
    environment: 'development'

# Configuration des alertes
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

# Fichiers de règles d'alerte
rule_files:
  - "alerts.yml"

# Configuration du scraping
scrape_configs:
  # Métriques Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
        labels:
          service: 'prometheus'

  # Métriques de l'application exemple
  - job_name: 'example-app'
    static_configs:
      - targets: ['app:5000']
        labels:
          service: 'example-api'
          environment: 'development'
    metrics_path: '/metrics'
    scrape_interval: 10s

  # Métriques système (Node Exporter)
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
        labels:
          service: 'system'
```

```yaml
# alerts.yml - Règles d'alerte
groups:
  - name: application_alerts
    interval: 30s
    rules:
      - alert: HighErrorRate
        expr: rate(app_errors_total[5m]) > 0.1
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} errors/second"

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High latency detected"
          description: "95th percentile latency is {{ $value }}s"

      - alert: ServiceDown
        expr: up{job="example-app"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
          description: "Example app service is not responding"
```

## Explications détaillées

**global.scrape_interval** : Fréquence de collecte par défaut

**alerting.alertmanagers** : Configuration d'Alertmanager

**rule_files** : Fichiers contenant les règles d'alerte

**scrape_configs** : Configuration des targets à scraper

**job_name** : Identifiant du job de scraping

**static_configs** : Liste statique des targets

**labels** : Métadonnées ajoutées aux métriques

**alerts.yml** : Règles pour déclencher des alertes

**expr** : Expression PromQL pour l'alerte

**for** : Durée avant déclenchement

## Vérification

1. Vérifiez les targets dans Prometheus (Status > Targets)
2. Vérifiez les métriques collectées (Graph)
3. Vérifiez les règles d'alerte (Alerts)

## Problèmes courants

- **Targets DOWN** : Vérifiez la connectivité réseau
- **Pas de métriques** : Vérifiez le chemin /metrics
- **Alertes non déclenchées** : Vérifiez la syntaxe PromQL

