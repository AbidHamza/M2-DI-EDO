# Exercice Phase 6 – Stack Loki + Promtail

## Objectif

Déployer Loki et Promtail via Docker Compose pour collecter les logs de l’application exemple (ou de vos conteneurs Docker) et vérifier qu’ils sont consultables dans Grafana.

## Étapes guidées

1. **Créer un fichier `loki-config.yml`**
   - `auth_enabled: false` (lab)
   - Ports : `http_listen_port: 3100`
   - Stockage : `filesystem` (`/loki/chunks`, `/loki/rules`)
   - Schéma : `boltdb-shipper` (simple et adapté aux environnements locaux)

2. **Créer `promtail-config.yml`**
   ```yaml
   server:
     http_listen_port: 9080
     grpc_listen_port: 0

   positions:
     filename: /tmp/positions.yaml

   clients:
     - url: http://loki:3100/loki/api/v1/push
   ```
   - Ajoutez deux `scrape_configs` :
     - Découverte des conteneurs Docker avec `docker_sd_configs` + `relabel_configs` (labels `container`, `service`, `stream`).
     - Lecture de fichiers `/var/log/app/*.log` avec `pipeline_stages` pour parser du JSON (`timestamp`, `level`, `message`).

3. **Écrire `docker-compose.yml`**
   ```yaml
   version: "3.8"
   services:
     loki:
       image: grafana/loki:latest
       ports:
         - "3100:3100"
       volumes:
         - ./loki-config.yml:/etc/loki/local-config.yaml
         - loki-data:/loki
       command: -config.file=/etc/loki/local-config.yaml

     promtail:
       image: grafana/promtail:latest
       volumes:
         - ./promtail-config.yml:/etc/promtail/config.yml
         - /var/run/docker.sock:/var/run/docker.sock
         - /var/log:/var/log:ro
       command: -config.file=/etc/promtail/config.yml
       depends_on:
         - loki

   volumes:
     loki-data:
   ```

4. **Lancer et tester**
   ```bash
   docker compose up -d
   curl http://localhost:3100/ready
   ```
   - Ajoutez Loki comme datasource dans Grafana (`http://localhost:3100`).
   - Dans Explore, exécutez `{service="example-app"}` puis `{service="example-app", level="ERROR"}`.

## Vérifications attendues

- Les conteneurs Loki/Promtail sont `UP`.
- Les logs de l’application apparaissent et peuvent être filtrés par label.
- Les pipelines JSON fonctionnent (le label `level` est disponible).
- Les positions (`positions.yaml`) sont mises à jour lorsque vous taillez un fichier.

## Solution expliquée

Le dossier `corrections/` contient une solution complète (config Loki + Promtail + requêtes LogQL). Consultez-la après votre tentative pour comprendre l’impact des paramètres (`limits_config`, `pipeline_stages`, `relabel_configs`).

## Variantes

- Ajouter un pipeline `multiline` pour regrouper les traces d’erreurs.
- Envoyer les logs vers Loki en HTTPS (avec authentification).
- Gérer la configuration via un rôle Ansible pour la réutiliser dans le projet principal.

