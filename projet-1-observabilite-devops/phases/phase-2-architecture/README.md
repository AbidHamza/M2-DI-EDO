# Phase 2 – Conception de l’architecture

Objectif : transformer la théorie de la phase 1 en une architecture claire montrant comment chaque composant sera déployé et comment les flux de données circuleront. Le livrable servira de plan pour les phases IaC (Terraform/Ansible) et pour la soutenance (20 % de la note).

## Ce que vous devez produire

1. **Schéma fonctionnel** : vues d’ensemble des composants (application exemple, Prometheus, Loki, Grafana, Alertmanager, exporters, Promtail, etc.) et de leurs interactions.
2. **Schéma de déploiement** : représentation de l’infrastructure (machines, réseaux, conteneurs, ports, stockage) + emplacement des outils IaC.
3. **Description textuelle des flux** : métriques, logs, alertes, dashboards, pipelines IaC.
4. **Cas d’usage détaillé** : quels indicateurs doivent être suivis, quels logs sont critiques, quelles alertes seront déclenchées.

## Méthodologie proposée

### 1. Partir des usages

- Identifiez les besoins métier : disponibilité de l’API Flask, latence, erreurs HTTP, volume de logs, alertes incident.
- Listez les questions auxquelles la plateforme doit répondre (ex : « Qui sera alerté si /metrics n’est plus accessible ? »).

### 2. Définir les composants

Pour chaque brique :
- **Application** : conteneur principal, endpoints, port 5000, export `/metrics`.
- **Prometheus** : collecte métriques, règle d’alerte, exposition sur 9090.
- **Exporters / service discovery** : configuration statique ou dynamique selon l’environnement.
- **Loki + Promtail** : chemin des logs, labels utilisés, règles de rétention.
- **Grafana** : datasources (Prometheus + Loki), dossiers de dashboards, variables communes.
- **Alertmanager** : routes, récepteurs, règles de groupement.
- **IaC** : Terraform pour créer les VM / réseaux / buckets, Ansible pour installer et paramétrer les services.

Présentez les dépendances (ex : Grafana dépend de Prometheus pour les métriques).

### 3. Cartographier les flux

Réalisez un tableau (ou section) avec :

| Flux | Source | Traitement | Destination | Notes |
| ---- | ------ | ---------- | ----------- | ----- |
| Métriques | Flask exporter | Scrape Prometheus toutes les 15 s | Prometheus TSDB | Labels app/service |
| Logs | Fichiers stdout / fichiers applicatifs | Promtail + labels custom | Loki | Conserver 7 jours |
| Alertes | Prometheus rules | Evaluation → Alertmanager | Email/Webhook | Critères CPU > 80 % etc. |
| Dashboards | Datasources Prometheus/Loki | Panels Grafana | Vue SRE | Variables environnements |

### 4. Définir l’architecture physique/logique

- Choisissez le style : tout sur une VM, plusieurs VMs, cluster Docker, etc. (même si vous restez en local, justifiez).
- Identifiez les ports, volumes, réseaux Docker, secrets nécessaires.
- Déterminez où s’exécuteront Terraform et Ansible (local, runner CI, etc.).

### 5. Préparer l’intégration IaC

- Listez les ressources Terraform à créer (ex : réseau, VM monitoring, stockage S3/MinIO).
- Listez les rôles Ansible envisagés (docker, prom, grafana, loki, alertmanager, app).
- Expliquez comment les variables seront partagées (fichiers `tfvars`, inventaire Ansible, variables d’environnement).

### 6. Livrables détaillés

- [ ] Schéma fonctionnel (image ou diagramme fait avec draw.io, Excalidraw, etc.)
- [ ] Schéma de déploiement + légende
- [ ] Document texte (peut être ce README ou un fichier `ARCHITECTURE.md`) décrivant :
  - les flux (tableau ci-dessus),
  - les ressources IaC prévues,
  - les hypothèses (local, cloud gratuit, contraintes réseau).
- [ ] Liste des dashboards/alertes prioritaires.

## Conseils

- Restez pragmatique : un schéma lisible vaut mieux qu’un diagramme UML complexe.
- Mentionnez les limites (ex : « Single node, donc HA limitée ») et les pistes d’évolution.
- Utilisez des couleurs ou numéros pour distinguer métriques/logs/alertes.
- Vérifiez que chaque composant décrit en phase 1 apparaît ici avec son rôle précis.

## Passage à la phase 3

Quand votre architecture est validée :
1. Enregistrez les schémas dans `docs/` (ou un sous-dossier dédié).
2. Ajoutez les flux décrits dans un fichier versionné.
3. Commitez vos fichiers (schéma exporté + documentation).
4. Ouvrez `phase-3-terraform/README.md` pour commencer le provisionnement à partir de ce plan.

