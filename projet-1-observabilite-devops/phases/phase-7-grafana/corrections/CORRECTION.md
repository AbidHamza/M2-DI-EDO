# Correction Phase 7 : Dashboards Grafana

## Dashboard 1 : Métriques Système

### Configuration du datasource

1. Configuration → Data Sources → Add data source
2. Sélectionner Prometheus
3. URL : http://prometheus:9090
4. Save & Test

### Panels à créer

**Panel 1 : CPU Usage**
- Query : `100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
- Type : Time series
- Unit : Percent (0-100)
- Title : CPU Usage

**Panel 2 : Memory Usage**
- Query : `(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100`
- Type : Time series
- Unit : Percent
- Title : Memory Usage

**Panel 3 : Disk Usage**
- Query : `(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100`
- Type : Time series
- Unit : Percent
- Title : Disk Usage

## Dashboard 2 : Métriques Applicatives

**Panel 1 : Request Rate**
- Query : `rate(http_requests_total[5m])`
- Type : Time series
- Unit : req/s
- Title : Request Rate

**Panel 2 : Latence P95**
- Query : `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
- Type : Time series
- Unit : seconds
- Title : Latency (P95)

**Panel 3 : Error Rate**
- Query : `rate(app_errors_total[5m])`
- Type : Time series
- Unit : errors/s
- Title : Error Rate

**Panel 4 : Service Status**
- Query : `up`
- Type : Stat
- Thresholds : 0.5 (rouge), 1 (vert)
- Title : Service Status

### Export du dashboard

1. Dashboard Settings → JSON Model
2. Copier le JSON
3. Sauvegarder dans un fichier pour versioning

