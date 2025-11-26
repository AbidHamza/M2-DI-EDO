# Exercice Phase 5 – Configurer Prometheus de A à Z

## Objectif

Construire un fichier `prometheus.yml` complet qui :
- scrappe l’application exemple (`/metrics`) ;
- récupère les métriques système (Node Exporter) ;
- déclare un lien avec Alertmanager ;
- charge un fichier de règles d’alertes.

## Étapes guidées

1. **Créer le fichier `prometheus.yml`**
   ```yaml
   global:
     scrape_interval: 15s
     evaluation_interval: 15s
     external_labels:
       cluster: observability-demo
       environment: development
   ```

2. **Configurer Alertmanager**
   ```yaml
   alerting:
     alertmanagers:
       - static_configs:
           - targets:
               - alertmanager:9093
   ```

3. **Déclarer les fichiers de règles**
   ```yaml
   rule_files:
     - "alerts.yml"
   ```

4. **Ajouter les `scrape_configs`**
   - Prometheus lui-même (`localhost:9090`)
   - Application (`app:5000`, `metrics_path: /metrics`, labels `service`/`environment`)
   - Node Exporter (`node-exporter:9100`)
   - Ajustez les intervalles (`scrape_interval`) si besoin.

5. **Créer `alerts.yml`**
   - Alertes recommandées :
     - `ServiceDown` : `up{job="example-app"} == 0`
     - `HighLatency` : `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1`
     - `HighErrorRate` : `rate(app_errors_total[5m]) > 0.1`
   - Fournissez labels (`severity`) et annotations (`summary`, `description`).

6. **Tester localement**
   - Lancez Prometheus en Docker :
     ```bash
     docker run -d --name prometheus \
       -p 9090:9090 \
       -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
       -v $(pwd)/alerts.yml:/etc/prometheus/alerts.yml \
       prom/prometheus:latest
     ```
   - Vérifiez les targets et les alertes dans l’interface.

## Vérifications

- Tous les jobs apparaissent en `UP`.
- Les métriques `http_request_duration_seconds` et `app_errors_total` existent (générer du trafic si nécessaire).
- Les alertes passent par les états `Pending` puis `Firing` lorsque vous simulez un incident (par exemple en arrêtant l’application).

## Solution expliquée

La configuration complète commentée se trouve dans `corrections/solution-expliquee` (fichier chiffré). Comparez avec votre travail pour vérifier :
- le nommage des jobs/labels ;
- la factorisation via des `scrape_configs` communs ;
- la pertinence des seuils.

## Pour aller plus loin

- Ajouter la découverte dynamique (`file_sd`, `docker_sd`) si vous utilisez Docker Compose ou Kubernetes.
- Tester des règles d’enregistrement (`recording rules`) pour simplifier certaines requêtes PromQL.
- Brancher directement Alertmanager et simuler l’envoi d’une notification.

