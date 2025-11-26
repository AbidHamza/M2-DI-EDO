# Phase 5 – Déploiement et configuration de Prometheus

Vous disposez maintenant d’une infrastructure et d’un outil d’automatisation. Cette phase se concentre sur la collecte de métriques via Prometheus, gérée par vos rôles Ansible.

## Objectif concret

- Déployer Prometheus (conteneur ou service) avec une configuration adaptée.
- Scraper l’application exemple, les exporters systèmes et tout composant pertinent.
- Préparer des règles d’alerte qui seront envoyées à Alertmanager (phase 8).

## Plan de travail recommandé

1. **Installer / déployer Prometheus**
   - Utilisez Ansible (`roles/prometheus`) ou Docker Compose.
   - Prévoyez un volume persistant (`/prometheus`).
   - Vérifiez que le service écoute sur le port 9090.

2. **Configurer `prometheus.yml`**
   - Bloc `global` : intervalles de scraping/évaluation.
   - `scrape_configs` :
     - Prometheus lui-même (`localhost:9090`).
     - Application Flask (`app:5000/metrics`).
     - Exporters système (Node Exporter `:9100`, cAdvisor, etc.).
     - Autres services (base de données, etc.) si disponibles.
   - `alerting` : pointez déjà vers Alertmanager (même si non déployé, laissez un placeholder).
   - `rule_files` : référencez vos fichiers d’alertes (`alerts/*.yml`).

3. **Ajouter les exporters nécessaires**
   - Node Exporter pour la machine (ou conteneur) Prometheus.
   - Exporter custom de l’application (ex: instrumentation Flask déjà fournie).
   - Documentez comment ajouter un nouvel exporter (fichier README).

4. **Valider les targets et les métriques**
   - Interface Prometheus → `Status > Targets`.
   - Page `Graph` pour tester vos requêtes PromQL (latence, erreurs, etc.).
   - Ajoutez au moins 2 règles d’alerte simples (service down, latence élevée).

5. **Automatiser via Ansible**
   - Template Jinja2 pour `prometheus.yml`.
   - Variables par environnement (ex: `group_vars/dev/prometheus.yml`).
   - Handler pour redémarrer Prometheus uniquement quand la config change.

## Livrables attendus

- Service Prometheus opérationnel (Docker/VM) et supervisé par Ansible.
- Fichier `prometheus.yml` propre, commenté et versionné.
- Exporters déployés + documentation pour les lancer/les surveiller.
- Requêtes PromQL et captures montrant les métriques collectées.
- Règles d’alerte initiales.

## Exercice associé

`EXERCICE.md` vous fait configurer un `prometheus.yml` complet (scraping application + Node Exporter + alertes). Réalisez-le pour consolider vos connaissances avant d’intégrer la configuration dans Ansible. La **solution expliquée** est disponible dans `corrections/`.

## Checklist de fin de phase

- [ ] Prometheus collecte les métriques de l’application exemple.
- [ ] Les targets apparaissent en `UP`.
- [ ] De premières alertes sont visibles dans l’onglet `Alerts`.
- [ ] La configuration est templatisée dans Ansible (pas de fichier manuel).
- [ ] Les ports/volumes sont documentés.

Vous pouvez maintenant passer à la **Phase 6 – Loki** pour centraliser les logs et compléter la stack d’observabilité.

