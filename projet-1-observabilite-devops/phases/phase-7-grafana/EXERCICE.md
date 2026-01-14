# Exercice Phase 7 – Deux dashboards Grafana

## Objectif

Construire deux dashboards :
1. **Infrastructure** – visibilité sur CPU, mémoire, disque, réseau, disponibilité.
2. **Application** – latence, débit, taux d’erreur, logs.

## Étapes guidées

1. **Configurer les datasources**
   - Prometheus : URL `http://prometheus:9090`.
   - Loki : URL `http://loki:3100`.

2. **Dashboard “System Metrics”**
   - Panels suggérés :
     - CPU : `100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
     - Mémoire utilisée : `node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes`
     - Disque : `node_filesystem_avail_bytes`
     - Réseau : `rate(node_network_receive_bytes_total[5m])` / `rate(node_network_transmit_bytes_total[5m])`
     - Disponibilité : `up{job="node-exporter"}`
   - Type de panneau : Graph/Stat.
   - Ajoutez des seuils (ex: CPU > 80 % = orange).

3. **Dashboard “Application Overview”**
   - Panels :
     - Débit : `rate(http_requests_total[5m])`
     - Latence p95 : `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
     - Taux d’erreur : `rate(app_errors_total[5m])`
     - Statut : `up{job="example-app"}`
     - Panel Logs (datasource Loki) : requête `{service="example-app"} |= "error"`
   - Ajoutez une variable `environment` pour filtrer (dev/staging/prod).

4. **Exporter les dashboards**
   - Menu `Share > Export > Save to file`.
   - Sauvegardez-les dans `dashboards/system.json` et `dashboards/application.json`.

## Vérifications

- Les panneaux affichent des données en temps réel.
- La variable `environment` filtre bien les panels.
- Le panel Logs affiche les entrées Loki et permet de filtrer les erreurs.

## Solution expliquée

Le dossier `corrections/` fournit des JSON d’exemple commentés (requêtes, unités, seuils). Utilisez-les comme référence après votre propre création.

## Pour aller plus loin

- Ajoutez des annotations (déploiements, incidents).
- Créez un dossier Grafana dédié à la stack observabilité et provisionnez les dashboards via code.

