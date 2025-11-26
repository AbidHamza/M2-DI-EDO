# Exercice Phase 7 : Création de dashboards Grafana

## Exercice à réaliser

Créez deux dashboards Grafana personnalisés : un pour les métriques système et un pour les métriques applicatives.

## Correction complète - Dashboard 1 : Métriques Système

```json
{
  "dashboard": {
    "title": "System Metrics",
    "panels": [
      {
        "title": "CPU Usage",
        "targets": [{
          "expr": "100 - (avg(irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)"
        }],
        "type": "graph"
      },
      {
        "title": "Memory Usage",
        "targets": [{
          "expr": "node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes"
        }],
        "type": "graph"
      }
    ]
  }
}
```

## Dashboard 2 : Métriques Applicatives

**Panel 1 : Taux de requêtes**
- Query : `rate(http_requests_total[5m])`
- Type : Graph
- Unit : req/s

**Panel 2 : Latence (p95)**
- Query : `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
- Type : Graph
- Unit : seconds

**Panel 3 : Taux d'erreur**
- Query : `rate(app_errors_total[5m])`
- Type : Graph
- Unit : errors/s

**Panel 4 : Statut des services**
- Query : `up`
- Type : Stat
- Thresholds : 0.5 (rouge), 1 (vert)

## Explications détaillées

**rate()** : Calcule le taux de changement par seconde

**histogram_quantile()** : Calcule un quantile (p95, p99)

**irate()** : Taux instantané (pour CPU)

**up** : Métrique Prometheus indiquant si un target est UP

## Import dans Grafana

1. Créez un nouveau dashboard
2. Ajoutez les panels
3. Configurez les queries PromQL
4. Personnalisez les visualisations
5. Exportez le dashboard (JSON)

## Vérification

Vérifiez que :
- Les dashboards affichent les données
- Les métriques sont à jour
- Les visualisations sont claires

