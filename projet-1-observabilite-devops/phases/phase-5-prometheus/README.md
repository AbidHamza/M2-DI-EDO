# Phase 5 : Déploiement de Prometheus

## Objectif de la phase

Configurer Prometheus pour collecter des métriques applicatives. Cette phase fait partie de la Partie 3 du sujet d'examen (40 points).

## Rappels techniques essentiels

### Configuration Prometheus

Prometheus se configure via `prometheus.yml` :
- **scrape_configs** : Configuration du scraping
- **alerting** : Configuration des alertes
- **rule_files** : Fichiers de règles

### Métriques à collecter

Pour une application :
- CPU, mémoire, disque
- Latence des requêtes
- Taux d'erreur
- Débit (throughput)

## Tâches du projet

### Étape 1 : Déploiement Prometheus

Déployez Prometheus avec Docker ou Ansible.

### Étape 2 : Configuration du scraping

Configurez :
- Targets à scraper
- Fréquence de scraping
- Labels

### Étape 3 : Exporters

Configurez des exporters pour :
- Node Exporter (métriques système)
- Application (métriques applicatives)

### Étape 4 : Validation

Vérifiez que Prometheus collecte les métriques.

## Livrable de la phase

- [ ] Prometheus déployé et fonctionnel
- [ ] Configuration du scraping
- [ ] Métriques collectées et visibles

## Prochaine phase

Passez à la **Phase 6 : Déploiement de Loki**.

