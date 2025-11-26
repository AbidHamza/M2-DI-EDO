# Projet M2DI-EDO - Chaîne CI/CD Sécurisée avec GitLab CI, SonarQube, Ansible et Terraform

## Bienvenue dans votre projet DevSecOps

Ce document est votre guide principal pour réaliser votre projet de Master 2. Vous allez concevoir et déployer une pipeline CI/CD sécurisée complète pour des applications web en suivant une approche pédagogique progressive, phase par phase.

## Vue d'ensemble du projet

Vous allez créer une **chaîne CI/CD sécurisée (DevSecOps)** capable d'automatiser le cycle de vie complet d'une application : du commit au déploiement, en intégrant des contrôles de qualité et de sécurité à chaque étape.

### Contexte métier

Dans un environnement où les applications doivent être livrées rapidement, fréquemment et avec un niveau de fiabilité élevé, la mise en place d'une chaîne CI/CD sécurisée est essentielle. Le défi n'est plus seulement d'automatiser les déploiements, mais aussi d'intégrer des contrôles de qualité logicielle et de sécurité dès les premières étapes du développement.

### Technologies utilisées

**CI/CD et qualité :**
- **GitLab CI** : Pipeline d'intégration et déploiement continu
- **SonarQube** : Analyse statique de code pour détecter bugs, vulnérabilités et code smells

**Infrastructure as Code :**
- **Terraform** : Provisionnement automatisé de l'infrastructure
- **Ansible** : Configuration et déploiement automatisés des applications

**Conteneurisation :**
- **Docker** : Conteneurisation des applications
- **Docker Registry** : Stockage des images Docker

**Sécurité :**
- **Gestionnaire de secrets** : Variables protégées GitLab ou Vault
- **Scan de sécurité** : Intégration dans le pipeline

## Objectifs pédagogiques

À la fin de ce projet, vous serez capable de :

### Compétences techniques

1. **CI/CD**
   - Comprendre les concepts DevSecOps
   - Créer des pipelines GitLab CI complets
   - Intégrer des étapes de test, build et déploiement
   - Automatiser le cycle de vie complet d'une application

2. **Qualité et sécurité**
   - Configurer SonarQube pour l'analyse de code
   - Intégrer l'analyse dans le pipeline CI/CD
   - Gérer les secrets de manière sécurisée
   - Comprendre les enjeux de sécurité dans le DevOps

3. **Infrastructure as Code**
   - Utiliser Terraform pour provisionner l'infrastructure
   - Utiliser Ansible pour automatiser la configuration
   - Comprendre les avantages de l'automatisation

4. **Intégration et automatisation**
   - Intégrer tous les composants de la chaîne
   - Automatiser les déploiements multi-environnements
   - Gérer les secrets et la configuration

### Compétences méthodologiques

- Structurer un projet DevSecOps de manière professionnelle
- Documenter les choix techniques et l'architecture
- Analyser les résultats et proposer des améliorations
- Comprendre les enjeux de traçabilité et d'auditabilité

## Structure du projet

```
projet-2-cicd-devsecops/
├── README.md                    # Ce fichier - Guide général
├── phases/                      # Guide pédagogique par phase
│   ├── phase-1-etude-theorique/
│   ├── phase-2-architecture/
│   ├── phase-3-gitlab-ci/
│   ├── phase-4-sonarqube/
│   ├── phase-5-terraform/
│   ├── phase-6-ansible/
│   ├── phase-7-securite/
│   ├── phase-8-integration/
│   ├── phase-9-multi-environnements/
│   └── phase-10-analyse-amelioration/
├── docs/                        # Documentation et ressources
│   ├── architecture.md
│   ├── pipeline-design.md
│   └── security-practices.md
├── terraform/                   # Scripts Terraform
├── ansible/                     # Playbooks Ansible
├── .gitlab-ci.yml              # Pipeline GitLab CI
├── application-example/         # Application exemple à déployer
└── sonarqube/                  # Configuration SonarQube
```

## Plan des phases - Vue d'ensemble

Le projet est organisé en 10 phases progressives correspondant aux parties du sujet d'examen.

### Phase 1 : Étude et présentation théorique (30 points)
**Durée estimée :** 4-5 heures  
**Objectif :** Comprendre les concepts DevSecOps et les outils  
**Livrable :** Présentation théorique des concepts et outils  
**Concepts clés :** DevSecOps, CI/CD, GitLab CI, SonarQube, IaC, Sécurité

### Phase 2 : Conception de l'architecture CI/CD (20 points)
**Durée estimée :** 3-4 heures  
**Objectif :** Concevoir l'architecture complète du pipeline  
**Livrable :** Schémas d'architecture du pipeline et des interactions  
**Concepts clés :** Architecture de pipeline, Étapes CI/CD, Intégration des outils

### Phase 3 : Mise en place du pipeline GitLab CI
**Durée estimée :** 5-6 heures  
**Objectif :** Créer le pipeline GitLab CI avec toutes les étapes  
**Livrable :** Pipeline fonctionnel avec tests, build, déploiement  
**Concepts clés :** GitLab CI, Jobs, Stages, Artifacts, Variables

### Phase 4 : Intégration de SonarQube
**Durée estimée :** 4-5 heures  
**Objectif :** Intégrer l'analyse de code dans le pipeline  
**Livrable :** SonarQube fonctionnel analysant le code à chaque commit  
**Concepts clés :** Analyse statique, Quality Gates, Rapports, Intégration CI

### Phase 5 : Provisionnement avec Terraform
**Durée estimée :** 4-5 heures  
**Objectif :** Automatiser le provisionnement de l'infrastructure  
**Livrable :** Scripts Terraform fonctionnels (local ou cloud)  
**Concepts clés :** Infrastructure as Code, Terraform, Providers, Modules

### Phase 6 : Configuration et déploiement avec Ansible
**Durée estimée :** 5-6 heures  
**Objectif :** Automatiser la configuration et le déploiement  
**Livrable :** Playbooks Ansible pour le déploiement automatique  
**Concepts clés :** Configuration Management, Playbooks, Roles, Inventories

### Phase 7 : Sécurisation de la chaîne
**Durée estimée :** 4-5 heures  
**Objectif :** Gérer les secrets et sécuriser le pipeline  
**Livrable :** Gestion sécurisée des secrets, scan de sécurité  
**Concepts clés :** Secrets Management, Variables protégées, Scan de vulnérabilités

### Phase 8 : Intégration complète
**Durée estimée :** 5-6 heures  
**Objectif :** Intégrer tous les composants et valider  
**Livrable :** Chaîne CI/CD complète et fonctionnelle  
**Concepts clés :** Intégration, Validation, Tests end-to-end

### Phase 9 : Multi-environnements
**Durée estimée :** 4-5 heures  
**Objectif :** Gérer les déploiements multi-environnements  
**Livrable :** Pipeline gérant dev, staging et production  
**Concepts clés :** Environnements, Promotion, Approbations

### Phase 10 : Analyse et amélioration (10 points)
**Durée estimée :** 3-4 heures  
**Objectif :** Analyser les résultats et proposer des améliorations  
**Livrable :** Rapport d'analyse avec propositions d'optimisation  
**Concepts clés :** Métriques, Performance, Scalabilité, Amélioration continue

**Durée totale estimée :** 40-50 heures

## Comment utiliser ce guide

### Méthodologie recommandée

1. **Lisez d'abord ce README** pour comprendre la vision globale
2. **Suivez les phases dans l'ordre** - chaque phase construit sur la précédente
3. **Pour chaque phase :**
   - Lisez attentivement les rappels techniques
   - Réalisez l'exercice pratique (fichier EXERCICE.md)
   - Suivez les instructions étape par étape
   - Vérifiez les livrables avant de passer à la suivante
4. **Testez régulièrement** votre pipeline
5. **Documentez** vos configurations et choix

### Conseils pour réussir

- **Comprenez le flux complet** : Visualisez le parcours du code du commit au déploiement
- **Testez chaque étape** : Validez chaque job du pipeline individuellement
- **Sécurisez dès le début** : Intégrez la sécurité dès la conception
- **Documentez** : Notez vos configurations et décisions

## Prérequis

Avant de commencer, assurez-vous d'avoir :

### Logiciels installés

- **Git** :** [git-scm.com](https://git-scm.com)
- **Docker** et **Docker Compose** : [docker.com](https://www.docker.com)
- **Terraform** (version 1.0+) : [terraform.io](https://www.terraform.io/downloads)
- **Ansible** (version 2.9+) : [ansible.com](https://docs.ansible.com/ansible/latest/installation_guide)
- **Un éditeur de code** : VS Code recommandé

### Services requis

**GitLab :**
- Compte GitLab (gratuit) : [gitlab.com](https://gitlab.com)
- Ou instance GitLab auto-hébergée

**SonarQube :**
- Instance SonarQube (Community Edition gratuite)
- Ou SonarCloud (gratuit pour projets open source)

### Environnement

**Option 1 : Local**
- Machine avec au moins 8GB RAM
- GitLab Runner local ou Docker
- Serveurs de déploiement (VMs ou conteneurs)

**Option 2 : Cloud**
- Compte AWS, Azure ou GCP
- GitLab CI/CD avec runners cloud
- Infrastructure cloud pour déploiement

**Option 3 : Hybride**
- GitLab cloud, déploiement local ou cloud

### Connaissances préalables

- Bases de Git (commits, branches, merge)
- Notions de conteneurisation (Docker)
- Compréhension des concepts CI/CD
- Utilisation basique de Linux

## Concepts clés à maîtriser

### DevSecOps

DevSecOps intègre la sécurité dans le processus DevOps :
- **Security as Code** : Sécurité intégrée dans le code et les pipelines
- **Shift Left** : Détection précoce des vulnérabilités
- **Automation** : Automatisation des contrôles de sécurité

### CI/CD

- **Continuous Integration (CI)** : Intégration continue du code
- **Continuous Deployment (CD)** : Déploiement continu automatique
- **Pipeline** : Série d'étapes automatisées

### Infrastructure as Code (IaC)

- **Terraform** : Provisionnement (création de ressources)
- **Ansible** : Configuration (installation et paramétrage)
- **Avantages** : Reproductibilité, versioning, cohérence

## Commandes essentielles

### GitLab CI

```bash
# Tester le pipeline localement (avec gitlab-runner)
gitlab-runner exec docker test

# Voir les jobs du pipeline
# Via l'interface GitLab ou API
```

### SonarQube

```bash
# Analyser un projet
sonar-scanner -Dsonar.projectKey=myproject

# Via Docker
docker run --rm -v $(pwd):/usr/src sonarsource/sonar-scanner-cli
```

### Terraform

```bash
# Initialiser
terraform init

# Planifier
terraform plan

# Appliquer
terraform apply
```

### Ansible

```bash
# Exécuter un playbook
ansible-playbook -i inventory playbook.yml

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml
```

## Bonnes pratiques à suivre

### Sécurité

- Ne jamais commiter les secrets dans Git
- Utiliser les variables protégées GitLab
- Scanner les dépendances pour les vulnérabilités
- Utiliser des images Docker sécurisées et à jour
- Implémenter le principe du moindre privilège

### Pipeline

- Garder les pipelines rapides (fail fast)
- Utiliser des caches pour accélérer les builds
- Séparer les stages (test, build, deploy)
- Implémenter des quality gates
- Documenter chaque étape

### Code

- Versionner tous les scripts et configurations
- Utiliser des modules Terraform réutilisables
- Créer des roles Ansible modulaires
- Maintenir une documentation à jour

## Ressources utiles

### Documentation officielle

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)

### Tutoriels

- [GitLab CI/CD Tutorial](https://docs.gitlab.com/ee/ci/quick_start/)
- [SonarQube Getting Started](https://docs.sonarqube.org/latest/getting-started/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)

## Aide et support

### Problèmes courants

**Pipeline GitLab échoue :**
- Vérifiez la syntaxe YAML
- Vérifiez les permissions des runners
- Consultez les logs des jobs

**SonarQube ne trouve pas le code :**
- Vérifiez les chemins dans sonar-project.properties
- Vérifiez les permissions d'accès
- Vérifiez la configuration du scanner

**Terraform échoue :**
- Vérifiez les credentials
- Vérifiez les permissions
- Vérifiez la syntaxe

### Où trouver de l'aide

1. **Documentation** : Consultez d'abord la documentation officielle
2. **Phases** : Relisez la phase concernée
3. **Communautés** : GitLab, SonarQube ont des communautés actives
4. **Enseignant** : N'hésitez pas à demander de l'aide

## Checklist de démarrage

Avant de commencer la Phase 1, vérifiez que vous avez :

- [ ] Compte GitLab créé
- [ ] Docker et Docker Compose installés
- [ ] Terraform installé (`terraform --version`)
- [ ] Ansible installé (`ansible --version`)
- [ ] Git installé et configuré
- [ ] Un éditeur de code installé
- [ ] Accès à un environnement (local ou cloud)
- [ ] Lu et compris ce README
- [ ] Créé un dépôt GitLab pour votre projet

## Prochaines étapes

1. **Créez votre dépôt GitLab** (si ce n'est pas déjà fait)
2. **Allez dans le dossier `phases/phase-1-etude-theorique/`**
3. **Lisez le README de la Phase 1**
4. **Commencez par l'exercice pratique** (fichier EXERCICE.md)
5. **Suivez les instructions étape par étape**

## Critères d'évaluation du projet

Votre projet sera évalué sur 100 points selon les critères suivants :

- **Compréhension théorique et clarté des explications (30 points)**
  - Qualité de la présentation DevSecOps
  - Compréhension des outils (GitLab CI, SonarQube, Terraform, Ansible)
  - Clarté des explications

- **Cohérence et pertinence de l'architecture proposée (20 points)**
  - Qualité du schéma d'architecture du pipeline
  - Pertinence des choix techniques
  - Description des interactions entre outils

- **Qualité de l'implémentation et maîtrise des outils (40 points)**
  - Pipeline GitLab CI fonctionnel et complet
  - Intégration SonarQube opérationnelle
  - Terraform et Ansible fonctionnels
  - Gestion sécurisée des secrets
  - Déploiement automatisé fonctionnel

- **Analyse critique et réflexion sur les axes d'amélioration (10 points)**
  - Évaluation des résultats (temps, fiabilité, qualité)
  - Identification des limites
  - Propositions d'amélioration pertinentes

## Conclusion

Ce projet vous permettra de maîtriser les outils essentiels du DevSecOps et de comprendre comment automatiser et sécuriser le cycle de vie complet d'une application. Vous acquerrez des compétences directement applicables dans un contexte professionnel.

Bon courage pour votre projet !

---

*Note : Ce guide est évolutif. N'hésitez pas à le consulter régulièrement et à prendre des notes sur vos apprentissages.*

