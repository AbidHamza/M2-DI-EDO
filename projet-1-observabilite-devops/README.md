# Projet M2DI-EDO - Observabilité Avancée avec Prometheus, Grafana, Loki et Alertmanager

## Bienvenue dans votre projet d'observabilité DevOps

Ce document est votre guide principal pour réaliser votre projet de Master 2. Vous allez concevoir et mettre en œuvre une solution d'observabilité complète pour des applications conteneurisées en suivant une approche pédagogique progressive, phase par phase.

## Vue d'ensemble du projet

Vous allez créer une **solution d'observabilité complète** pour superviser des applications conteneurisées. Cette solution intégrera la collecte de métriques, l'ingestion de logs, la visualisation et l'alerting, le tout automatisé avec Terraform et Ansible.

### Contexte métier

Dans les environnements modernes basés sur des microservices conteneurisés, la résilience et la performance doivent être mesurées et améliorées en continu. En tant qu'ingénieur SRE (Site Reliability Engineer), vous devez concevoir et industrialiser une solution d'observabilité complète reposant exclusivement sur des technologies open source.

### Technologies utilisées

**Collecte et stockage :**
- **Prometheus** : Système de monitoring et collecte de métriques
- **Loki** : Système d'agrégation et d'indexation des logs

**Visualisation et alerting :**
- **Grafana** : Plateforme de visualisation et création de dashboards
- **Alertmanager** : Gestion et routage des alertes

**Infrastructure as Code :**
- **Terraform** : Provisionnement automatisé de l'infrastructure
- **Ansible** : Configuration et déploiement automatisés

**Conteneurisation :**
- **Docker** : Conteneurisation des applications et des outils d'observabilité

## Objectifs pédagogiques

À la fin de ce projet, vous serez capable de :

### Compétences techniques

1. **Observabilité**
   - Comprendre les principes de l'observabilité moderne (métriques, logs, traces)
   - Configurer Prometheus pour la collecte de métriques
   - Configurer Loki pour l'ingestion et l'indexation des logs
   - Créer des dashboards Grafana pertinents
   - Configurer Alertmanager pour les alertes automatisées

2. **Infrastructure as Code**
   - Utiliser Terraform pour provisionner l'infrastructure
   - Utiliser Ansible pour automatiser la configuration
   - Comprendre les avantages de l'IaC (reproductibilité, cohérence)

3. **Intégration et automatisation**
   - Intégrer tous les composants d'observabilité
   - Automatiser le déploiement complet
   - Tester la solution avec des scénarios réels

### Compétences méthodologiques

- Structurer un projet DevOps de manière professionnelle
- Documenter les choix techniques et l'architecture
- Analyser les performances et proposer des améliorations
- Comprendre les enjeux de scalabilité et haute disponibilité

## Structure du projet

```
projet-1-observabilite-devops/
├── README.md                    # Ce fichier - Guide général
├── phases/                      # Guide pédagogique par phase
│   ├── phase-1-etude-theorique/
│   ├── phase-2-architecture/
│   ├── phase-3-terraform/
│   ├── phase-4-ansible/
│   ├── phase-5-prometheus/
│   ├── phase-6-loki/
│   ├── phase-7-grafana/
│   ├── phase-8-alertmanager/
│   ├── phase-9-integration/
│   └── phase-10-tests-analyse/
├── docs/                        # Documentation et ressources
│   ├── architecture.md
│   ├── prometheus-config.md
│   └── best-practices.md
├── terraform/                   # Scripts Terraform
├── ansible/                     # Playbooks Ansible
├── docker-compose/              # Configuration Docker
└── application-example/         # Application exemple à superviser
```

## Plan des phases - Vue d'ensemble

Le projet est organisé en 10 phases progressives correspondant aux parties du sujet d'examen.

### Phase 1 : Étude et présentation théorique (30 points)
**Durée estimée :** 4-5 heures  
**Objectif :** Comprendre les concepts et outils d'observabilité  
**Livrable :** Présentation théorique des outils et concepts  
**Concepts clés :** Observabilité, Prometheus, Grafana, Loki, Alertmanager, IaC

### Phase 2 : Conception de l'architecture (20 points)
**Durée estimée :** 3-4 heures  
**Objectif :** Concevoir l'architecture complète de la solution  
**Livrable :** Schémas d'architecture et diagrammes de flux  
**Concepts clés :** Architecture distribuée, Flux de données, Intégration des composants

### Phase 3 : Provisionnement avec Terraform
**Durée estimée :** 4-5 heures  
**Objectif :** Automatiser le provisionnement de l'infrastructure  
**Livrable :** Scripts Terraform fonctionnels (local ou cloud)  
**Concepts clés :** Infrastructure as Code, Terraform, Providers, State management

### Phase 4 : Configuration avec Ansible
**Durée estimée :** 4-5 heures  
**Objectif :** Automatiser la configuration des serveurs  
**Livrable :** Playbooks Ansible pour l'installation et la configuration  
**Concepts clés :** Configuration Management, Playbooks, Roles, Inventories

### Phase 5 : Déploiement de Prometheus
**Durée estimée :** 3-4 heures  
**Objectif :** Configurer Prometheus pour la collecte de métriques  
**Livrable :** Prometheus fonctionnel collectant des métriques applicatives  
**Concepts clés :** Métriques, Scraping, Service Discovery, Exporters

### Phase 6 : Déploiement de Loki
**Durée estimée :** 3-4 heures  
**Objectif :** Configurer Loki pour l'ingestion des logs  
**Livrable :** Loki fonctionnel ingérant les logs applicatifs  
**Concepts clés :** Logs, Ingestion, Indexation, Labels

### Phase 7 : Création de dashboards Grafana
**Durée estimée :** 4-5 heures  
**Objectif :** Créer des dashboards pertinents pour la visualisation  
**Livrable :** Au minimum 2 dashboards personnalisés fonctionnels  
**Concepts clés :** Visualisation, Dashboards, Panels, Queries

### Phase 8 : Configuration d'Alertmanager
**Durée estimée :** 3-4 heures  
**Objectif :** Configurer le système d'alertes automatisées  
**Livrable :** Alertmanager fonctionnel avec notifications (email/webhook)  
**Concepts clés :** Alertes, Routing, Grouping, Notifications

### Phase 9 : Intégration complète
**Durée estimée :** 4-5 heures  
**Objectif :** Intégrer tous les composants et valider le fonctionnement  
**Livrable :** Solution complète fonctionnelle  
**Concepts clés :** Intégration, Validation, Tests end-to-end

### Phase 10 : Tests, analyse et amélioration (10 points)
**Durée estimée :** 3-4 heures  
**Objectif :** Tester la solution et proposer des améliorations  
**Livrable :** Rapport d'analyse avec propositions d'optimisation  
**Concepts clés :** Tests de charge, Analyse de performance, Scalabilité, HA

**Durée totale estimée :** 35-45 heures

## Comment utiliser ce guide

### Méthodologie recommandée

1. **Lisez d'abord ce README** pour comprendre la vision globale
2. **Suivez les phases dans l'ordre** - chaque phase construit sur la précédente
3. **Pour chaque phase :**
   - Lisez attentivement les rappels techniques
   - Réalisez l'exercice pratique (fichier EXERCICE.md)
   - Suivez les instructions étape par étape
   - Vérifiez les livrables avant de passer à la suivante
4. **Testez régulièrement** votre infrastructure
5. **Documentez** vos choix et configurations

### Conseils pour réussir

- **Comprenez avant d'implémenter** : Prenez le temps de comprendre chaque outil
- **Testez progressivement** : Validez chaque composant avant de passer au suivant
- **Documentez** : Notez vos configurations et choix techniques
- **Expérimentez** : N'hésitez pas à tester différents scénarios

## Prérequis

Avant de commencer, assurez-vous d'avoir :

### Logiciels installés

- **Docker** et **Docker Compose** : [docker.com](https://www.docker.com)
- **Terraform** (version 1.0+) : [terraform.io](https://www.terraform.io/downloads)
- **Ansible** (version 2.9+) : [ansible.com](https://docs.ansible.com/ansible/latest/installation_guide)
- **Git** : [git-scm.com](https://git-scm.com)
- **Un éditeur de code** : VS Code recommandé

### Environnement

**Option 1 : Local**
- Machine avec au moins 8GB RAM
- Accès root/sudo pour Docker
- Plusieurs VMs ou conteneurs pour simuler l'infrastructure

**Option 2 : Cloud**
- Compte AWS, Azure ou GCP (tiers gratuit disponible)
- Accès API pour Terraform
- Budget limité pour les ressources

**Option 3 : Hybride**
- Développement local, déploiement cloud pour la démonstration

### Connaissances préalables

- Bases de Linux (commandes, fichiers de configuration)
- Notions de conteneurisation (Docker)
- Compréhension des concepts réseau (ports, protocoles)
- Utilisation basique de Git

## Concepts clés à maîtriser

### Observabilité

L'observabilité est la capacité à comprendre l'état interne d'un système à partir de ses sorties externes. Elle repose sur trois piliers :
- **Métriques** : Mesures numériques dans le temps (CPU, mémoire, latence)
- **Logs** : Événements textuels avec timestamp
- **Traces** : Chemins d'exécution à travers les services (optionnel pour ce projet)

### Infrastructure as Code (IaC)

L'IaC permet de gérer l'infrastructure via du code plutôt que manuellement :
- **Terraform** : Provisionnement (création de ressources)
- **Ansible** : Configuration (installation et paramétrage)

### Monitoring vs Observabilité

- **Monitoring** : Surveillance passive avec alertes
- **Observabilité** : Capacité active à explorer et comprendre le système

## Commandes essentielles

### Terraform

```bash
# Initialiser Terraform
terraform init

# Planifier les changements
terraform plan

# Appliquer les changements
terraform apply

# Détruire l'infrastructure
terraform destroy
```

### Ansible

```bash
# Tester la connexion
ansible all -i inventory -m ping

# Exécuter un playbook
ansible-playbook -i inventory playbook.yml

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml
```

### Docker

```bash
# Démarrer les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down
```

## Bonnes pratiques à suivre

### Sécurité

- Ne jamais commiter les secrets dans Git
- Utiliser des variables d'environnement ou un gestionnaire de secrets
- Limiter les accès réseau (firewall, security groups)
- Utiliser des images Docker officielles et à jour

### Code et configuration

- Versionner tous les scripts Terraform et Ansible
- Utiliser des modules Terraform réutilisables
- Créer des roles Ansible modulaires
- Documenter les variables et paramètres

### Monitoring

- Collecter uniquement les métriques pertinentes
- Configurer des rétentions appropriées
- Créer des dashboards orientés action
- Configurer des alertes utiles (pas trop, pas trop peu)

## Ressources utiles

### Documentation officielle

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)

### Tutoriels et guides

- [Prometheus Getting Started](https://prometheus.io/docs/introduction/overview/)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)

## Aide et support

### Problèmes courants

**Erreur de connexion Prometheus :**
- Vérifiez que les targets sont accessibles
- Vérifiez la configuration de scraping
- Vérifiez les ports et firewall

**Alertes non déclenchées :**
- Vérifiez les règles d'alertes dans Prometheus
- Vérifiez la configuration d'Alertmanager
- Vérifiez les routes et récepteurs

**Terraform échoue :**
- Vérifiez les credentials cloud
- Vérifiez les permissions
- Vérifiez la syntaxe des fichiers

### Où trouver de l'aide

1. **Documentation** : Consultez d'abord la documentation officielle
2. **Phases** : Relisez la phase concernée
3. **Communautés** : Prometheus, Grafana ont des communautés actives
4. **Enseignant** : N'hésitez pas à demander de l'aide

## Checklist de démarrage

Avant de commencer la Phase 1, vérifiez que vous avez :

- [ ] Docker et Docker Compose installés
- [ ] Terraform installé (`terraform --version`)
- [ ] Ansible installé (`ansible --version`)
- [ ] Git installé et configuré
- [ ] Un éditeur de code installé
- [ ] Accès à un environnement (local ou cloud)
- [ ] Lu et compris ce README
- [ ] Créé un dépôt Git pour votre projet

## Prochaines étapes

1. **Créez votre dépôt Git** (si ce n'est pas déjà fait)
2. **Allez dans le dossier `phases/phase-1-etude-theorique/`**
3. **Lisez le README de la Phase 1**
4. **Commencez par l'exercice pratique** (fichier EXERCICE.md)
5. **Suivez les instructions étape par étape**

## Critères d'évaluation du projet

Votre projet sera évalué sur 100 points selon les critères suivants :

- **Compréhension théorique et clarté des explications (30 points)**
  - Qualité de la présentation des outils
  - Compréhension des concepts IaC
  - Clarté des explications

- **Cohérence et pertinence de l'architecture proposée (20 points)**
  - Qualité du schéma d'architecture
  - Pertinence des choix techniques
  - Description des flux de données

- **Qualité de l'implémentation et maîtrise des outils (40 points)**
  - Fonctionnement de Terraform et Ansible
  - Configuration correcte des outils
  - Dashboards pertinents
  - Système d'alertes fonctionnel
  - Tests de validation

- **Analyse critique et rigueur du rapport (10 points)**
  - Évaluation des performances
  - Propositions d'amélioration pertinentes
  - Qualité de la réflexion

## Conclusion

Ce projet vous permettra de maîtriser les outils essentiels de l'observabilité moderne et de comprendre comment automatiser le déploiement d'infrastructure. Vous acquerrez des compétences directement applicables dans un contexte professionnel d'ingénierie SRE.

Bon courage pour votre projet !

---

*Note : Ce guide est évolutif. N'hésitez pas à le consulter régulièrement et à prendre des notes sur vos apprentissages.*

