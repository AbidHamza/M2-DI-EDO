# Phase 6 – Centralisation des logs avec Loki + Promtail

Après les métriques, place aux logs. Cette phase vise à déployer Loki pour stocker/chercher les logs applicatifs et Promtail pour les collecter. Vous préparerez ainsi tout ce qu’il faut pour les panels “logs” dans Grafana.

## Objectif concret

- Déployer Loki (service ou conteneur) avec stockage persistant.
- Configurer Promtail pour collecter les logs de l’application, des composants systèmes ou de Docker.
- Définir une convention de labels/log streams afin de retrouver les événements facilement.

## Plan d’action

1. **Installer Loki**
   - Utilisez votre rôle Ansible ou Docker Compose.
   - Exposez le port 3100.
   - Choisissez un backend de stockage : filesystem (projet local) ou objet (S3/MinIO) pour un déploiement cloud.

2. **Configurer Promtail**
   - Définissez les `scrape_configs` (fichiers log, journaux Docker, etc.).
   - Ajoutez des `relabel_configs` pour enrichir les logs avec `service`, `environment`, `level`, `instance`.
   - Stockez les positions (`positions`) pour éviter les doublons après redémarrage.

3. **Normaliser les labels**
   - `service`, `job`, `environment`, `container`, `level` sont des labels utiles pour les requêtes LogQL.
   - Documentez les conventions pour l’équipe (ex : `service=api`, `environment=dev`).

4. **Valider l’ingestion**
   - Utilisez `http://loki:3100/ready`.
   - Dans Grafana → Explore → Datasource Loki, testez les requêtes `{service="example-app"}`.
   - Vérifiez les pipelines (parse JSON, extraire `level`, etc.).

5. **Automatiser**
   - Intégrez Loki/Promtail à Ansible (rôles séparés ou rôle `logging`).
   - Rendez les chemins/labels configurables (variables).

## Livrables attendus

- Services Loki et Promtail opérationnels.
- Fichiers de configuration (`loki-config.yml`, `promtail-config.yml` ou templates Ansible) versionnés.
- Convention de labels documentée.
- Preuve que les logs applicatifs remontent et peuvent être filtrés (captures, requêtes LogQL).

## Exercice associé

`EXERCICE.md` décrit une configuration complète Loki + Promtail avec Docker Compose. Faites-le tourner localement pour maîtriser les options (pipelines, relabel). La **solution expliquée** est fournie dans `corrections/`.

## Checklist

- [ ] Loki écoute sur 3100 et répond /ready.
- [ ] Promtail pousse les logs de l’application exemple (labels cohérents).
- [ ] Je peux exécuter une requête LogQL pour filtrer les erreurs.
- [ ] Les fichiers de configuration sont gérés par Ansible (ou un template).
- [ ] Les conventions de labels sont partagées dans la documentation.

Une fois les logs disponibles, vous pourrez les visualiser aux côtés des métriques dans Grafana (phase 7).

