# Phase 7 – Dashboards et visualisations Grafana

Cette phase valorise les métriques/logs collectés. Vous devez livrer des dashboards actionnables démontrant l’état de l’application et de l’infrastructure.

## Objectif concret

- Configurer les datasources (Prometheus + Loki).
- Créer au moins deux dashboards personnalisés (système, applicatif, logs).
- Documenter chaque panel (requête, seuils, usage).

## Plan d’action

1. **Brancher les datasources**
   - Datasource Prometheus : URL `http://prometheus:9090`.
   - Datasource Loki : URL `http://loki:3100`.
   - Configurez l’authentification si nécessaire (basic auth, token).

2. **Créer un dashboard “Infrastructure”**
   - Panels proposés : CPU, mémoire, disque, réseau, disponibilité des services (`up`).
   - Ajoutez des seuils (warning/critical) pour rendre les panels exploitables.

3. **Créer un dashboard “Application”**
   - Panels : taux de requêtes, latence p95, taux d’erreur, statut des dépendances.
   - Ajoutez des variables (ex: environnement, service) pour filtrer rapidement.

4. **Ajouter un panel Logs**
   - Panel “Logs” ou “Logs search” pointant sur Loki.
   - Requêtes LogQL préconfigurées (`{service="example-app"}` ou `|= "error"`).

5. **Documenter chaque dashboard**
   - Description du besoin métier couvert.
   - Liste des panels + requêtes PromQL/LogQL dans un fichier `docs/dashboards.md` ou dans les annotations du dashboard.

6. **Exporter et versionner**
   - Export JSON des dashboards (`dashboards/system.json`, `dashboards/application.json`).
   - Optionnel : automatiser l’import via Ansible ou Grafana provisioning.

## Livrables attendus

- Au moins deux dashboards (.json) importables.
- Captures d’écran avec exemples de données réelles.
- Documentation expliquant comment réutiliser/adapter les dashboards.
- Panel logs fonctionnel (optionnel mais fortement conseillé).

## Exercice associé

`EXERCICE.md` propose un pas-à-pas pour créer deux dashboards (système et application) avec panels clés. Inspirez-vous-en pour structurer vos versions finales. Une **solution expliquée** est disponible dans `corrections/`.

## Checklist

- [ ] Datasources Prometheus et Loki configurées.
- [ ] ≥ 2 dashboards avec panels pertinents.
- [ ] Variables et légendes pour naviguer facilement.
- [ ] Exports JSON versionnés.
- [ ] Documentation sur l’utilisation des dashboards.

Une fois cette phase validée, vous serez prêts pour la **Phase 8 – Alertmanager** afin de traduire vos règles d’alertes en notifications actionnables.

