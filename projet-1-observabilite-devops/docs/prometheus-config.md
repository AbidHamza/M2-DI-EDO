# Guide de Configuration Prometheus

## Configuration de base

### Structure prometheus.yml

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

## Types de métriques

### Counter
Compteur qui ne peut qu'augmenter :
```python
requests_total = Counter('requests_total', 'Total requests')
requests_total.inc()
```

### Gauge
Valeur qui peut augmenter ou diminuer :
```python
cpu_usage = Gauge('cpu_usage', 'CPU usage')
cpu_usage.set(75.5)
```

### Histogram
Distribution de valeurs :
```python
request_duration = Histogram('request_duration_seconds', 'Request duration')
request_duration.observe(0.5)
```

## Service Discovery

### Docker
```yaml
scrape_configs:
  - job_name: 'docker'
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
```

### Kubernetes
```yaml
scrape_configs:
  - job_name: 'kubernetes'
    kubernetes_sd_configs:
      - role: pod
```

## Requêtes PromQL courantes

### Taux de requêtes
```promql
rate(http_requests_total[5m])
```

### Latence p95
```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

### Taux d'erreur
```promql
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])
```

## Règles d'alerte

### Exemple
```yaml
groups:
  - name: example
    rules:
      - alert: HighErrorRate
        expr: rate(errors_total[5m]) > 0.1
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High error rate"
```

