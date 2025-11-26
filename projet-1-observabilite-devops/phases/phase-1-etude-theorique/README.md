# Phase 1 : Étude et présentation théorique

## Objectif de la phase

Comprendre les concepts fondamentaux de l'observabilité moderne et maîtriser les outils Prometheus, Grafana, Loki et Alertmanager. Cette phase correspond à la Partie 1 du sujet d'examen (30 points).

## Rappels techniques essentiels

### Observabilité vs Monitoring

**Monitoring traditionnel :**
- Surveillance passive avec alertes prédéfinies
- Métriques pré-configurées
- Approche réactive

**Observabilité moderne :**
- Capacité à explorer et comprendre le système
- Trois piliers : Métriques, Logs, Traces
- Approche proactive et exploratoire

### Les trois piliers de l'observabilité

1. **Métriques (Metrics)**
   - Mesures numériques dans le temps
   - Exemples : CPU, mémoire, latence, débit
   - Stockage efficace, agrégation facile

2. **Logs**
   - Événements textuels avec timestamp
   - Contexte détaillé des événements
   - Recherche et analyse

3. **Traces (optionnel pour ce projet)**
   - Chemins d'exécution à travers les services
   - Compréhension des dépendances
   - Analyse de performance distribuée

### Prometheus

**Qu'est-ce que Prometheus ?**
- Système de monitoring et d'alerte open source
- Collecte des métriques via pull (scraping)
- Stockage time-series efficace
- Langage de requête PromQL

**Architecture :**
- Prometheus Server : Collecte et stocke les métriques
- Exporters : Exposent les métriques des applications
- Service Discovery : Découverte automatique des targets
- Alertmanager : Gestion des alertes

**Concepts clés :**
- **Metrics** : Types (Counter, Gauge, Histogram, Summary)
- **Scraping** : Collecte périodique des métriques
- **PromQL** : Langage de requête pour les métriques
- **Alerting Rules** : Règles pour déclencher des alertes

### Grafana

**Qu'est-ce que Grafana ?**
- Plateforme open source de visualisation et d'analyse
- Connexion à multiples sources de données
- Création de dashboards interactifs
- Alerting intégré

**Fonctionnalités :**
- Dashboards personnalisables
- Panels variés (graphiques, tableaux, jauges)
- Variables de dashboard
- Annotations et alertes visuelles

### Loki

**Qu'est-ce que Loki ?**
- Système d'agrégation de logs open source
- Conçu pour être simple et économique
- Indexation par labels (pas par contenu)
- Intégration native avec Grafana

**Architecture :**
- Distributor : Réception des logs
- Ingester : Stockage des logs
- Querier : Requêtes sur les logs
- Index : Indexation par labels

**Concepts clés :**
- **Labels** : Métadonnées pour indexer les logs
- **LogQL** : Langage de requête pour les logs
- **Streams** : Flux de logs avec mêmes labels

### Alertmanager

**Qu'est-ce qu'Alertmanager ?**
- Gestion et routage des alertes Prometheus
- Groupement et déduplication
- Routage vers différents récepteurs
- Silencing et inhibition

**Fonctionnalités :**
- Grouping : Regrouper les alertes similaires
- Routing : Diriger vers les bons canaux
- Notifications : Email, webhook, Slack, etc.
- Silencing : Masquer temporairement des alertes

### Infrastructure as Code (IaC)

**Concepts :**
- Gestion de l'infrastructure via du code
- Versioning de l'infrastructure
- Reproductibilité et cohérence
- Automatisation complète

**Terraform :**
- Provisionnement d'infrastructure
- Multi-cloud support
- State management
- Plan et Apply

**Ansible :**
- Configuration management
- Idempotence
- Playbooks et Roles
- Agentless

## Exercice pratique : Comprendre l'écosystème

**Consultez le fichier EXERCICE.md dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
- Installer et configurer Prometheus localement
- Comprendre le scraping de métriques
- Créer des règles d'alerte simples
- Visualiser les métriques dans Grafana

## Tâches du projet

### Étape 1 : Étudier Prometheus

**À faire :**
1. Lire la documentation officielle de Prometheus
2. Comprendre l'architecture et les concepts
3. Identifier les cas d'usage
4. Préparer une présentation (5-7 slides)

**Points à couvrir :**
- Architecture générale
- Modèle de données (métriques, labels)
- Scraping et service discovery
- PromQL (exemples de requêtes)
- Intégration avec les applications

### Étape 2 : Étudier Grafana

**À faire :**
1. Lire la documentation officielle de Grafana
2. Comprendre les fonctionnalités principales
3. Identifier les types de panels
4. Préparer une présentation (3-5 slides)

**Points à couvrir :**
- Architecture et rôles
- Types de datasources
- Création de dashboards
- Variables et templating
- Alerting dans Grafana

### Étape 3 : Étudier Loki

**À faire :**
1. Lire la documentation officielle de Loki
2. Comprendre le modèle de données
3. Comprendre LogQL
4. Préparer une présentation (3-5 slides)

**Points à couvrir :**
- Architecture et composants
- Modèle de données (labels, streams)
- LogQL (exemples de requêtes)
- Intégration avec Promtail
- Différences avec Elasticsearch

### Étape 4 : Étudier Alertmanager

**À faire :**
1. Lire la documentation officielle d'Alertmanager
2. Comprendre le routage des alertes
3. Comprendre le grouping et silencing
4. Préparer une présentation (2-3 slides)

**Points à couvrir :**
- Architecture et rôles
- Configuration du routage
- Récepteurs (email, webhook)
- Grouping et déduplication

### Étape 5 : Étudier l'IaC

**À faire :**
1. Comprendre les concepts d'Infrastructure as Code
2. Étudier Terraform (provisionnement)
3. Étudier Ansible (configuration)
4. Préparer une présentation (5-7 slides)

**Points à couvrir :**
- Concepts IaC et avantages
- Terraform : provisionnement, state, providers
- Ansible : playbooks, roles, idempotence
- Complémentarité Terraform + Ansible
- Cas d'usage dans DevOps

### Étape 6 : Cas d'usage

**À faire :**
1. Identifier des cas d'usage concrets
2. Préparer une présentation (3-5 slides)

**Exemples de cas d'usage :**
- Monitoring d'applications microservices
- Analyse de logs distribués
- Supervision de performance
- Détection proactive d'incidents
- Amélioration continue basée sur les métriques

## Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Présentation PowerPoint (minimum 20 slides) couvrant :
  - Prometheus (architecture, concepts, cas d'usage)
  - Grafana (fonctionnalités, dashboards)
  - Loki (architecture, LogQL)
  - Alertmanager (routage, notifications)
  - Concepts IaC et justification Terraform/Ansible
  - Cas d'usage d'une solution d'observabilité
- [ ] Compréhension claire de chaque outil
- [ ] Identification des interactions entre outils
- [ ] Documentation de vos recherches

## Vérification

Testez votre compréhension :

1. **Pouvez-vous expliquer** la différence entre monitoring et observabilité ?
2. **Pouvez-vous décrire** comment Prometheus collecte les métriques ?
3. **Pouvez-vous expliquer** pourquoi Loki est différent d'Elasticsearch ?
4. **Pouvez-vous justifier** l'utilisation de Terraform et Ansible ensemble ?

## Problèmes courants

- **Confusion monitoring/observabilité** : Lisez les articles de référence
- **Complexité de PromQL** : Pratiquez avec des exemples simples
- **Compréhension de l'IaC** : Faites des exercices pratiques

## Notes importantes

- Cette phase est théorique mais essentielle
- Prenez le temps de bien comprendre chaque outil
- La présentation sera évaluée (30 points)
- Documentez vos sources

## Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 2 : Conception de l'architecture**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 1: Étude théorique des outils d'observabilité"
```

