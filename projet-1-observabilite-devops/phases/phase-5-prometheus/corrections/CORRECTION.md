# Correction Phase 5 : Configuration Prometheus complète

## Correction de l'exercice

### Configuration prometheus.yml complète

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'observability-demo'
    environment: 'development'

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

rule_files:
  - "alerts.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
        labels:
          service: 'prometheus'

  - job_name: 'example-app'
    static_configs:
      - targets: ['app:5000']
        labels:
          service: 'example-api'
          environment: 'development'
    metrics_path: '/metrics'
    scrape_interval: 10s

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
        labels:
          service: 'system'
```

### Fichier alerts.yml

```yaml
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

### Explications détaillées

**global.scrape_interval** : Fréquence par défaut de collecte (15 secondes)

**alerting.alertmanagers** : Configuration pour envoyer les alertes à Alertmanager

**rule_files** : Fichiers contenant les règles d'alerte

**scrape_configs** : Configuration des cibles à scraper
- `job_name` : Identifiant du job
- `static_configs` : Liste statique des cibles
- `labels` : Métadonnées ajoutées aux métriques

**Règles d'alerte** :
- `expr` : Expression PromQL pour déclencher l'alerte
- `for` : Durée avant déclenchement
- `labels` : Labels ajoutés à l'alerte
- `annotations` : Informations détaillées

### Vérification

1. Vérifiez les targets : Status → Targets (tous doivent être UP)
2. Vérifiez les métriques : Graph → tapez `up`
3. Vérifiez les alertes : Alerts → vos règles doivent apparaître

