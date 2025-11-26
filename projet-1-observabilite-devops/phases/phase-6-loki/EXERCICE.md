# Exercice Phase 6 : Configuration complète de Loki

## Exercice à réaliser

Configurez Loki pour ingérer et indexer les logs de l'application exemple.

## Correction complète

### Configuration Loki

```yaml
# loki-config.yml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

ruler:
  alertmanager_url: http://alertmanager:9093

# Limites
limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  ingestion_rate_mb: 16
  ingestion_burst_size_mb: 32
```

### Configuration Promtail

```yaml
# promtail-config.yml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  # Logs depuis Docker
  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container'
      - source_labels: ['__meta_docker_container_log_stream']
        target_label: 'stream'
      - source_labels: ['__meta_docker_container_label_com_docker_compose_service']
        target_label: 'service'
    
  # Logs depuis fichiers
  - job_name: app-logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: example-app
          environment: development
          __path__: /var/log/app/*.log
    pipeline_stages:
      - json:
          expressions:
            timestamp: timestamp
            level: level
            message: message
      - labels:
          level:
      - timestamp:
          source: timestamp
          format: RFC3339
```

### Docker Compose pour Loki

```yaml
# docker-compose-loki.yml
version: '3.8'

services:
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    volumes:
      - ./loki-config.yml:/etc/loki/local-config.yaml
      - loki-data:/loki
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - observability

  promtail:
    image: grafana/promtail:latest
    volumes:
      - ./promtail-config.yml:/etc/promtail/config.yml
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/log:/var/log:ro
    command: -config.file=/etc/promtail/config.yml
    networks:
      - observability
    depends_on:
      - loki

volumes:
  loki-data:

networks:
  observability:
    external: true
```

## Explications détaillées

### Configuration Loki

**server** : Ports d'écoute HTTP et gRPC

**common.storage** : Stockage des chunks et règles

**schema_config** : Configuration du schéma de stockage

**limits_config** : Limites de taux et taille

### Configuration Promtail

**clients** : URL de Loki pour envoyer les logs

**scrape_configs** : Configuration de collecte

**docker_sd_configs** : Découverte automatique des conteneurs Docker

**relabel_configs** : Transformation des labels

**pipeline_stages** : Traitement des logs (parse JSON, extraction)

### Labels importants

Les labels permettent d'indexer et de rechercher :
- `job` : Nom du job
- `service` : Nom du service
- `environment` : Environnement (dev, prod)
- `level` : Niveau de log (INFO, ERROR)

## Requêtes LogQL

### Requêtes de base

```logql
# Tous les logs d'un service
{service="example-app"}

# Logs d'erreur
{service="example-app", level="ERROR"}

# Logs avec un texte spécifique
{service="example-app"} |= "error"

# Comptage de logs par niveau
sum(count_over_time({service="example-app"}[5m])) by (level)

# Taux d'erreur
rate({service="example-app", level="ERROR"}[5m])
```

## Intégration avec Grafana

1. Ajoutez Loki comme datasource dans Grafana
2. URL : `http://loki:3100`
3. Créez des panels de logs dans vos dashboards
4. Utilisez LogQL pour filtrer et analyser

## Vérification

1. Vérifiez que Loki ingère les logs :
   ```bash
   curl http://localhost:3100/ready
   ```

2. Vérifiez les logs dans Grafana :
   - Créez un panel de type "Logs"
   - Utilisez la query : `{service="example-app"}`

3. Testez les requêtes LogQL dans Grafana Explore

## Problèmes courants

- **Pas de logs** : Vérifiez la configuration Promtail
- **Labels manquants** : Vérifiez relabel_configs
- **Logs non parsés** : Vérifiez pipeline_stages

## Prochaine phase

Passez à la **Phase 7 : Création de dashboards Grafana**.

