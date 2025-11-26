# Phase 1 : Étude et présentation théorique

## Objectif de la phase

Comprendre les concepts DevSecOps et maîtriser les outils GitLab CI, SonarQube, Terraform et Ansible. Cette phase correspond à la Partie 1 du sujet d'examen (30 points).

## Rappels techniques essentiels

### DevOps vs DevSecOps

**DevOps classique :**
- Intégration du développement et des opérations
- Automatisation du cycle de vie
- Focus sur la vitesse et la fiabilité

**DevSecOps :**
- Intégration de la sécurité dans DevOps
- Security as Code
- Shift Left : sécurité dès le début
- Automatisation des contrôles de sécurité

**Différences clés :**
- Sécurité intégrée, pas ajoutée après
- Détection précoce des vulnérabilités
- Automatisation des scans de sécurité
- Culture de sécurité partagée

### GitLab CI/CD

**Qu'est-ce que GitLab CI ?**
- Système d'intégration et déploiement continu intégré à GitLab
- Pipeline défini dans `.gitlab-ci.yml`
- Runners pour exécuter les jobs
- Intégration native avec le repository

**Concepts clés :**
- **Pipeline** : Série d'étapes automatisées
- **Stages** : Groupes de jobs exécutés en parallèle
- **Jobs** : Tâches individuelles (test, build, deploy)
- **Runners** : Machines qui exécutent les jobs
- **Artifacts** : Fichiers produits par les jobs
- **Variables** : Configuration et secrets

**Avantages :**
- Intégration native avec Git
- Interface graphique intuitive
- Support multi-environnements
- Gestion des secrets intégrée

### SonarQube

**Qu'est-ce que SonarQube ?**
- Plateforme d'analyse statique de code
- Détection automatique de bugs, vulnérabilités et code smells
- Support de nombreux langages
- Quality Gates pour bloquer les mauvais codes

**Fonctionnalités :**
- Analyse de code source
- Détection de vulnérabilités de sécurité
- Détection de bugs et code smells
- Mesure de la couverture de code
- Rapports détaillés

**Concepts clés :**
- **Quality Gate** : Seuils de qualité à respecter
- **Issues** : Bugs, vulnérabilités, code smells
- **Coverage** : Couverture de code par les tests
- **Technical Debt** : Dette technique

**Intégration CI/CD :**
- Scanner dans le pipeline
- Blocage si Quality Gate échoue
- Rapports intégrés dans GitLab

### Terraform

**Qu'est-ce que Terraform ?**
- Outil d'Infrastructure as Code
- Provisionnement d'infrastructure multi-cloud
- Déclaratif (décrit l'état désiré)
- State management

**Concepts clés :**
- **Providers** : Plugins pour différentes plateformes
- **Resources** : Composants d'infrastructure
- **State** : État actuel de l'infrastructure
- **Plan** : Prévisualisation des changements
- **Apply** : Application des changements

**Avantages :**
- Multi-cloud support
- Versioning de l'infrastructure
- Reproductibilité
- Plan avant application

### Ansible

**Qu'est-ce qu'Ansible ?**
- Outil de configuration management
- Automatisation des tâches d'administration
- Agentless (pas d'agent à installer)
- Idempotent (peut être exécuté plusieurs fois)

**Concepts clés :**
- **Playbooks** : Fichiers YAML décrivant les tâches
- **Roles** : Réutilisation de configurations
- **Modules** : Tâches prédéfinies
- **Inventories** : Liste des serveurs à gérer
- **Idempotence** : Résultat identique à chaque exécution

**Avantages :**
- Simple (YAML)
- Agentless
- Idempotent
- Large écosystème de modules

### Complémentarité Terraform + Ansible

**Terraform :**
- Provisionne l'infrastructure (créer les serveurs)
- Gère les ressources cloud
- State management

**Ansible :**
- Configure les serveurs (installer, configurer)
- Déploie les applications
- Gère la configuration

**Workflow typique :**
1. Terraform crée les serveurs
2. Ansible configure et déploie

### Enjeux dans un contexte applicatif critique

**Applications financières :**
- Données sensibles (informations bancaires)
- Conformité réglementaire
- Disponibilité critique
- Audit et traçabilité

**Exigences de sécurité :**
- Chiffrement des données
- Authentification forte
- Logs d'audit
- Contrôles d'accès stricts

**Exigences de qualité :**
- Code sans vulnérabilités
- Tests complets
- Documentation à jour
- Performance optimale

## Exercice pratique : Premiers pas avec GitLab CI

**Consultez le fichier EXERCICE.md dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
- Créer un pipeline GitLab CI simple
- Comprendre les stages et jobs
- Utiliser les variables
- Créer des artifacts

## Tâches du projet

### Étape 1 : Étudier DevSecOps

**À faire :**
1. Rechercher et comprendre DevSecOps
2. Comparer avec DevOps classique
3. Identifier les avantages
4. Préparer une présentation (5-7 slides)

**Points à couvrir :**
- Définition et principes DevSecOps
- Différences avec DevOps
- Avantages et bénéfices
- Cas d'usage
- Bonnes pratiques

### Étape 2 : Étudier GitLab CI

**À faire :**
1. Lire la documentation officielle de GitLab CI
2. Comprendre l'architecture
3. Comprendre les concepts (pipeline, stages, jobs)
4. Préparer une présentation (5-7 slides)

**Points à couvrir :**
- Architecture GitLab CI
- Concepts (pipeline, stages, jobs, runners)
- Syntaxe `.gitlab-ci.yml`
- Variables et secrets
- Artifacts et caches
- Intégration avec GitLab

### Étape 3 : Étudier SonarQube

**À faire :**
1. Lire la documentation officielle de SonarQube
2. Comprendre l'analyse statique
3. Comprendre les Quality Gates
4. Préparer une présentation (5-7 slides)

**Points à couvrir :**
- Architecture SonarQube
- Types d'analyses (bugs, vulnérabilités, code smells)
- Quality Gates
- Intégration CI/CD
- Rapports et métriques

### Étape 4 : Étudier Terraform

**À faire :**
1. Lire la documentation officielle de Terraform
2. Comprendre l'Infrastructure as Code
3. Comprendre les concepts clés
4. Préparer une présentation (4-6 slides)

**Points à couvrir :**
- Concepts IaC
- Architecture Terraform
- Providers et resources
- State management
- Plan et Apply
- Modules

### Étape 5 : Étudier Ansible

**À faire :**
1. Lire la documentation officielle d'Ansible
2. Comprendre la configuration management
3. Comprendre les playbooks et roles
4. Préparer une présentation (4-6 slides)

**Points à couvrir :**
- Concepts configuration management
- Architecture Ansible
- Playbooks et roles
- Modules et inventories
- Idempotence
- Cas d'usage

### Étape 6 : Enjeux applicatifs critiques

**À faire :**
1. Identifier les enjeux spécifiques
2. Comprendre les exigences de sécurité
3. Préparer une présentation (3-5 slides)

**Points à couvrir :**
- Contexte applicatif critique (finances, données sensibles)
- Exigences de sécurité
- Exigences de qualité
- Exigences de conformité
- Traçabilité et audit

## Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Présentation PowerPoint (minimum 20 slides) couvrant :
  - DevSecOps vs DevOps
  - GitLab CI (architecture, concepts, intégration)
  - SonarQube (analyse, quality gates, intégration)
  - Terraform (IaC, concepts, providers)
  - Ansible (configuration management, playbooks)
  - Enjeux applicatifs critiques
- [ ] Compréhension claire de chaque outil
- [ ] Identification des interactions entre outils
- [ ] Documentation de vos recherches

## Vérification

Testez votre compréhension :

1. **Pouvez-vous expliquer** la différence entre DevOps et DevSecOps ?
2. **Pouvez-vous décrire** le fonctionnement d'un pipeline GitLab CI ?
3. **Pouvez-vous expliquer** comment SonarQube détecte les vulnérabilités ?
4. **Pouvez-vous justifier** l'utilisation de Terraform et Ansible ensemble ?

## Problèmes courants

- **Confusion DevOps/DevSecOps** : Focus sur l'intégration de la sécurité
- **Complexité GitLab CI** : Commencez par des pipelines simples
- **Compréhension SonarQube** : Testez avec un projet simple

## Notes importantes

- Cette phase est théorique mais essentielle
- Prenez le temps de bien comprendre chaque outil
- La présentation sera évaluée (30 points)
- Documentez vos sources

## Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 2 : Conception de l'architecture CI/CD**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 1: Étude théorique DevSecOps et outils"
```

