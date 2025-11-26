# Rappels théoriques : Prometheus Avancé

## Service Discovery

### Concept

Prometheus peut découvrir automatiquement les targets à scraper au lieu de les configurer manuellement.

### Types de service discovery

1. **Static Config** : Configuration manuelle
2. **File-based** : Découverte via fichiers
3. **Kubernetes** : Découverte dans K8s
4. **Docker** : Découverte des conteneurs
5. **Consul** : Découverte via Consul
6. **EC2** : Découverte dans AWS EC2

### Service Discovery Kubernetes

```yaml
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        target_label: __address__
        regex: (.+)
        replacement: $1:9090
```

### Relabeling

Permet de transformer les labels avant le scraping.

**Actions** :
- `keep` : Garder si regex match
- `drop` : Supprimer si regex match
- `replace` : Remplacer un label
- `labelmap` : Mapper des labels

**Exemple** :
```yaml
relabel_configs:
  - source_labels: [__meta_kubernetes_pod_name]
    target_label: pod_name
  - source_labels: [__meta_kubernetes_namespace]
    target_label: namespace
```

## Recording Rules

### Concept

Pré-calcule des expressions PromQL fréquemment utilisées pour améliorer les performances.

**Avantages** :
- Requêtes plus rapides
- Réduction de la charge
- Agrégation pré-calculée

**Exemple** :
```yaml
groups:
  - name: example_rules
    interval: 30s
    rules:
      - record: job:http_requests:rate5m
        expr: rate(http_requests_total[5m])
      - record: job:http_errors:rate5m
        expr: rate(http_requests_total{status=~"5.."}[5m])
```

## Métriques personnalisées

### Types de métriques

1. **Counter** : Compteur qui augmente
2. **Gauge** : Valeur qui monte/descend
3. **Histogram** : Distribution de valeurs
4. **Summary** : Résumé statistique

### Exemple Python

```python
from prometheus_client import Counter, Gauge, Histogram, start_http_server

# Counter
requests_total = Counter('requests_total', 'Total requests', ['method', 'endpoint'])

# Gauge
active_connections = Gauge('active_connections', 'Active connections')

# Histogram
request_duration = Histogram('request_duration_seconds', 'Request duration')

# Utilisation
requests_total.labels(method='GET', endpoint='/api').inc()
active_connections.set(42)
request_duration.observe(0.5)
```

## PromQL Avancé

### Fonctions utiles

**rate()** : Taux de changement par seconde
```promql
rate(http_requests_total[5m])
```

**increase()** : Augmentation sur une période
```promql
increase(http_requests_total[1h])
```

**histogram_quantile()** : Quantile d'un histogramme
```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

**sum() / avg()** : Agrégation
```promql
sum(rate(http_requests_total[5m])) by (service)
```

### Opérateurs

**Arithmétique** :
```promql
cpu_usage_percent = (1 - cpu_idle / cpu_total) * 100
```

**Comparaison** :
```promql
http_errors > 10
```

**Logique** :
```promql
up == 0 or rate(errors[5m]) > 0.1
```

## Exercices pratiques

### Exercice 1 : Service Discovery Kubernetes

**Objectif** : Configurer la découverte automatique des Pods.

**Tâches** :
1. Configurez Prometheus pour découvrir les Pods K8s
2. Ajoutez les annotations nécessaires sur les Pods
3. Utilisez relabeling pour nettoyer les labels

**Solution** : Voir `corrections/EXERCICE-1-SERVICE-DISCOVERY.md.encrypted`

### Exercice 2 : Recording Rules

**Objectif** : Créer des règles d'enregistrement pour optimiser les dashboards.

**Tâches** :
1. Créez des recording rules pour les métriques fréquentes
2. Utilisez ces règles dans un dashboard Grafana
3. Comparez les performances

**Solution** : Voir `corrections/EXERCICE-2-RECORDING-RULES.md.encrypted`

### Exercice 3 : Métriques personnalisées

**Objectif** : Instrumenter une application avec des métriques Prometheus.

**Tâches** :
1. Ajoutez des métriques Counter, Gauge, Histogram
2. Exposez-les sur /metrics
3. Configurez Prometheus pour les scraper

**Solution** : Voir `corrections/EXERCICE-3-METRICS.md.encrypted`

## Configuration avancée

### Rétention des données

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'

# Limites de stockage
storage:
  tsdb:
    path: /prometheus
    retention.time: 30d
    retention.size: 50GB
```

### Alerting Rules avancées

```yaml
groups:
  - name: application_alerts
    interval: 30s
    rules:
      - alert: HighErrorRate
        expr: |
          (
            sum(rate(http_requests_total{status=~"5.."}[5m])) by (service)
            /
            sum(rate(http_requests_total[5m])) by (service)
          ) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate in {{ $labels.service }}"
          description: "Error rate is {{ $value | humanizePercentage }}"
```

## Bonnes pratiques

1. **Labels cohérents** : Utilisez des labels standards
2. **Cardinalité** : Évitez les labels à haute cardinalité
3. **Recording Rules** : Pour les requêtes complexes
4. **Rétention** : Configurez selon vos besoins
5. **Service Discovery** : Automatisez la découverte

## Ressources supplémentaires

- [Prometheus Documentation](https://prometheus.io/docs/)
- [PromQL Guide](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Service Discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

