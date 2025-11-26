# Phase 2 : Conception de l'architecture

## Objectif de la phase

Concevoir l'architecture complète de la solution d'observabilité en intégrant tous les composants. Cette phase correspond à la Partie 2 du sujet d'examen (20 points).

## Rappels techniques essentiels

### Architecture distribuée

Une solution d'observabilité moderne est distribuée :
- Composants séparés et spécialisés
- Communication via APIs
- Scalabilité horizontale
- Haute disponibilité

### Flux de données

**Collecte de métriques :**
1. Application expose des métriques (exporters)
2. Prometheus scrape les métriques
3. Prometheus stocke les métriques
4. Grafana interroge Prometheus

**Ingestion de logs :**
1. Application génère des logs
2. Promtail collecte les logs
3. Loki ingère et indexe les logs
4. Grafana interroge Loki

**Alertes :**
1. Prometheus évalue les règles d'alerte
2. Alertes envoyées à Alertmanager
3. Alertmanager route les alertes
4. Notifications (email, webhook)

## Tâches du projet

### Étape 1 : Schéma d'architecture global

Créez un schéma montrant :
- Tous les composants (Prometheus, Grafana, Loki, Alertmanager)
- Les flux de données
- Les interactions entre composants
- L'infrastructure (serveurs, conteneurs)

### Étape 2 : Schéma de déploiement

Créez un schéma montrant :
- Architecture de déploiement
- Intégration Terraform (provisionnement)
- Intégration Ansible (configuration)
- Environnements (dev, prod)

### Étape 3 : Description des flux

Documentez :
- Flux de collecte de métriques
- Flux d'ingestion de logs
- Flux d'alertes
- Flux de visualisation

### Étape 4 : Cas pratique

Décrivez :
- Application à superviser (fournie ou développée)
- Métriques à collecter
- Logs à ingérer
- Dashboards nécessaires
- Alertes à configurer

## Livrable de la phase

- [ ] Schéma d'architecture complet
- [ ] Schéma de déploiement
- [ ] Description des flux de données
- [ ] Description du cas pratique
- [ ] Diagrammes UML si nécessaire

## Prochaine phase

Passez à la **Phase 3 : Provisionnement avec Terraform**.

