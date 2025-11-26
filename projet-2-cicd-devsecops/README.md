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
│   ├── pipeline-design.md      # Design du pipeline CI/CD
│   ├── security-practices.md    # Pratiques de sécurité
│   ├── alternatives-gratuites.md # Services gratuits pour CI/CD
│   └── rappels-theoriques/      # Rappels théoriques détaillés
│       ├── git-avance.md       # Git avancé avec exercices
│       └── docker-avance.md    # Docker pour CI/CD
├── scripts/                     # Scripts utilitaires
│   ├── decrypt.sh              # Déchiffrer les corrections (étudiants)
│   ├── encrypt.sh              # Chiffrer les corrections (enseignant)
│   ├── encrypt-all.sh          # Chiffrer toutes les corrections (Linux/Mac)
│   └── encrypt-all.ps1         # Chiffrer toutes les corrections (Windows)
├── application-example/         # Application exemple à déployer
│   ├── main.py                 # API FastAPI
│   ├── Dockerfile              # Image Docker
│   └── tests/                  # Tests unitaires
├── .gitlab-ci.yml              # Pipeline GitLab CI
└── COMMENT-ACCEDER-AUX-CORRECTIONS.md # Guide pour accéder aux corrections
```

## Plan des phases - Vue d'ensemble

Le projet est organisé en 10 phases progressives correspondant aux parties du sujet d'examen.

### Phase 1 : Étude et présentation théorique (30 points)
**Objectif :** Comprendre les concepts DevSecOps et les outils  
**Livrable :** Présentation théorique des concepts et outils  
**Concepts clés :** DevSecOps, CI/CD, GitLab CI, SonarQube, IaC, Sécurité

### Phase 2 : Conception de l'architecture CI/CD (20 points)
**Objectif :** Concevoir l'architecture complète du pipeline  
**Livrable :** Schémas d'architecture du pipeline et des interactions  
**Concepts clés :** Architecture de pipeline, Étapes CI/CD, Intégration des outils

### Phase 3 : Mise en place du pipeline GitLab CI
**Objectif :** Créer le pipeline GitLab CI avec toutes les étapes  
**Livrable :** Pipeline fonctionnel avec tests, build, déploiement  
**Concepts clés :** GitLab CI, Jobs, Stages, Artifacts, Variables

### Phase 4 : Intégration de SonarQube
**Objectif :** Intégrer l'analyse de code dans le pipeline  
**Livrable :** SonarQube fonctionnel analysant le code à chaque commit  
**Concepts clés :** Analyse statique, Quality Gates, Rapports, Intégration CI

### Phase 5 : Provisionnement avec Terraform
**Objectif :** Automatiser le provisionnement de l'infrastructure  
**Livrable :** Scripts Terraform fonctionnels (local ou services gratuits)  
**Concepts clés :** Infrastructure as Code, Terraform, Providers, Modules

### Phase 6 : Configuration et déploiement avec Ansible
**Objectif :** Automatiser la configuration et le déploiement  
**Livrable :** Playbooks Ansible pour le déploiement automatique  
**Concepts clés :** Configuration Management, Playbooks, Roles, Inventories

### Phase 7 : Sécurisation de la chaîne
**Objectif :** Gérer les secrets et sécuriser le pipeline  
**Livrable :** Gestion sécurisée des secrets, scan de sécurité  
**Concepts clés :** Secrets Management, Variables protégées, Scan de vulnérabilités

### Phase 8 : Intégration complète
**Objectif :** Intégrer tous les composants et valider  
**Livrable :** Chaîne CI/CD complète et fonctionnelle  
**Concepts clés :** Intégration, Validation, Tests end-to-end

### Phase 9 : Multi-environnements
**Objectif :** Gérer les déploiements multi-environnements  
**Livrable :** Pipeline gérant dev, staging et production  
**Concepts clés :** Environnements, Promotion, Approbations

### Phase 10 : Analyse et amélioration (10 points)
**Objectif :** Analyser les résultats et proposer des améliorations  
**Livrable :** Rapport d'analyse avec propositions d'optimisation  
**Concepts clés :** Métriques, Performance, Scalabilité, Amélioration continue

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

### Logiciels installés (tous gratuits)

**Windows :**
- **Git** : [git-scm.com/download/win](https://git-scm.com/download/win) (gratuit)
- **Docker Desktop** : [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) (gratuit)
- **Terraform** : [terraform.io/downloads](https://www.terraform.io/downloads) (gratuit)
- **Ansible** : `pip install ansible` (nécessite Python, gratuit)
- **Python** : [python.org/downloads](https://www.python.org/downloads/) (gratuit)
- **Un éditeur de code** : VS Code recommandé (gratuit)

**Linux :**
- **Git** : `sudo apt install git` (gratuit)
- **Docker** : `sudo apt install docker.io docker-compose` (gratuit)
- **Terraform** : Voir [terraform.io/downloads](https://www.terraform.io/downloads) (gratuit)
- **Ansible** : `sudo apt install ansible` (gratuit)
- **Python** : Généralement déjà installé (gratuit)

**Mac :**
- **Git** : Généralement déjà installé, sinon `brew install git` (gratuit)
- **Docker Desktop** : [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) (gratuit)
- **Terraform** : `brew install terraform` (gratuit)
- **Ansible** : `brew install ansible` (gratuit)
- **Python** : Généralement déjà installé (gratuit)

### Services requis (tous gratuits)

**GitLab :**
- Compte GitLab.com (gratuit) : [gitlab.com](https://gitlab.com)
- 2000 minutes de CI/CD gratuites par mois
- Suffisant pour ce projet

**SonarQube :**
- **Option 1** : SonarCloud (gratuit pour projets open source) : [sonarcloud.io](https://sonarcloud.io)
- **Option 2** : SonarQube Community Edition en local (gratuit) : `docker run -d -p 9000:9000 sonarqube:community`

**Note :** Tous les outils et services sont 100% gratuits. Consultez `docs/alternatives-gratuites.md` pour plus de détails.

### Environnement

**Option 1 : Local (recommandé - 100% gratuit)**
- Machine avec au moins 8GB RAM
- Docker Desktop installé (gratuit)
- GitLab Runner local ou Docker
- Développement et tests en local
- Pas de coût, fonctionne sur Windows, Linux et Mac

**Option 2 : Services gratuits pour déploiement**
- **GitLab.com** : Compte gratuit avec CI/CD (2000 minutes/mois)
- **Railway** : Déploiement gratuit (500h/mois) - parfait pour les APIs
- **Render** : Déploiement gratuit (limite de temps) - excellent pour les apps web
- **Fly.io** : Déploiement gratuit (limites généreuses) - idéal pour les conteneurs
- **Vercel** : Déploiement gratuit pour applications web et APIs
- **GitHub Codespaces** : Environnement de développement gratuit (60h/mois)

**Option 3 : Hybride**
- GitLab cloud (gratuit), déploiement sur services gratuits
- Développement local, CI/CD sur GitLab, déploiement sur Railway/Render

### Connaissances préalables

- Bases de Git (commits, branches, merge)
- Notions de conteneurisation (Docker)
- Compréhension des concepts CI/CD
- Utilisation basique de Linux

## Concepts clés à maîtriser - Explications détaillées

### DevSecOps - Sécurité intégrée dès le début

DevSecOps est l'évolution de DevOps qui intègre la sécurité à chaque étape du cycle de développement. Au lieu d'ajouter la sécurité à la fin (comme un pansement), elle est intégrée dès le début.

**Les trois principes fondamentaux :**

1. **Security as Code (Sécurité comme Code)**
   - **Concept** : La sécurité est définie dans le code, versionnée, testée
   - **Exemple** : Les règles de sécurité sont dans des fichiers YAML, versionnées dans Git
   - **Avantage** : Même sécurité partout, traçable, reproductible

2. **Shift Left (Décaler vers la gauche)**
   - **Concept** : Détecter les problèmes de sécurité le plus tôt possible
   - **Exemple** : Scanner le code à chaque commit, pas seulement avant la production
   - **Avantage** : Moins cher de corriger tôt, moins de risques

3. **Automation (Automatisation)**
   - **Concept** : Automatiser tous les contrôles de sécurité
   - **Exemple** : Scan automatique des dépendances, tests de sécurité dans le pipeline
   - **Avantage** : Pas d'oubli, cohérence, rapidité

**Pourquoi DevSecOps est important ?**
- Les failles de sécurité coûtent cher (financièrement et en réputation)
- La détection précoce est 10x moins chère que la correction en production
- La sécurité devient une responsabilité partagée, pas juste celle de l'équipe sécurité

**Différence DevOps vs DevSecOps :**
```
DevOps classique :
Code → Build → Test → Deploy
                    ↑
              Sécurité ajoutée ici (trop tard)

DevSecOps :
Code → Security Scan → Build → Security Test → Deploy
       ↑                                    ↑
  Sécurité dès le début          Sécurité à chaque étape
```

### CI/CD - Automatisation du cycle de vie

CI/CD signifie Continuous Integration (Intégration Continue) et Continuous Deployment (Déploiement Continu). C'est l'automatisation complète du cycle de vie d'une application.

**Continuous Integration (CI) - Intégration Continue**

**Définition** : Intégrer automatiquement le code de plusieurs développeurs dans un dépôt partagé plusieurs fois par jour.

**Processus typique :**
```
1. Développeur fait un commit
2. Pipeline CI se déclenche automatiquement
3. Tests automatiques s'exécutent
4. Analyse de code (SonarQube)
5. Build de l'application
6. Si tout passe → Code intégré
7. Si échec → Notification au développeur
```

**Avantages :**
- Détection précoce des bugs
- Code toujours fonctionnel
- Réduction des conflits entre développeurs

**Continuous Deployment (CD) - Déploiement Continu**

**Définition** : Déployer automatiquement le code validé en production.

**Processus typique :**
```
1. Code validé par CI
2. Pipeline CD se déclenche
3. Provisionnement infrastructure (Terraform)
4. Configuration serveurs (Ansible)
5. Déploiement application
6. Tests de validation
7. Application en production
```

**Avantages :**
- Déploiements rapides et fréquents
- Moins d'erreurs humaines
- Feedback rapide des utilisateurs

**Pipeline CI/CD complet :**
```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  Code   │───▶│   Test  │───▶│  Build  │───▶│ Deploy  │
│ Commit  │    │  Quality│    │  Image  │    │  Prod   │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
     │              │              │              │
     ▼              ▼              ▼              ▼
  GitLab         SonarQube      Docker       Railway
```

### Infrastructure as Code (IaC) - Infrastructure versionnée

L'IaC permet de gérer l'infrastructure (serveurs, réseaux, configurations) comme du code. C'est révolutionnaire car avant, on configurait tout manuellement.

**Pourquoi l'IaC est essentiel ?**

**Avant l'IaC (méthode manuelle) :**
- Configuration manuelle → Erreurs humaines
- Pas de traçabilité → Qui a changé quoi ?
- Difficile à reproduire → "Ça marchait sur ma machine"
- Long à déployer → Heures ou jours

**Avec l'IaC :**
- Configuration automatisée → Moins d'erreurs
- Versionnée dans Git → Traçabilité complète
- Reproducible → Même résultat partout
- Rapide → Minutes pour déployer

**Les deux outils complémentaires :**

1. **Terraform - Le constructeur**
   - **Rôle** : Crée les ressources (serveurs, réseaux)
   - **Exemple** : "Crée un serveur avec ces spécifications"
   - **Avantage** : Multi-cloud, déclaratif
   - **Quand l'utiliser** : Pour créer l'infrastructure

2. **Ansible - Le configurateur**
   - **Rôle** : Configure ce qui existe (installe, configure)
   - **Exemple** : "Installe Docker et démarre l'application"
   - **Avantage** : Idempotent, simple (YAML)
   - **Quand l'utiliser** : Pour configurer et déployer

**Workflow complet :**
```
1. Terraform crée les serveurs
   └─> Infrastructure prête (machines vides)

2. Ansible configure les serveurs
   └─> Applications installées et configurées

3. Résultat
   └─> Système complet et fonctionnel
```

**Avantages combinés :**
- **Reproductibilité** : Même infrastructure à chaque fois
- **Versioning** : Suivre les changements dans Git
- **Rapidité** : Automatisation complète
- **Cohérence** : Pas de "dérive de configuration"

## Commandes essentielles

### GitLab CI

**Windows (PowerShell ou Git Bash) :**
```powershell
# Installer GitLab Runner (optionnel pour tests locaux)
# Télécharger depuis: https://docs.gitlab.com/runner/install/windows.html

# Tester le pipeline localement (avec gitlab-runner)
gitlab-runner exec docker test

# Voir les jobs du pipeline
# Via l'interface GitLab web (https://gitlab.com)
```

**Linux/Mac :**
```bash
# Installer GitLab Runner
# Linux: https://docs.gitlab.com/runner/install/linux-manually.html
# Mac: https://docs.gitlab.com/runner/install/osx.html

# Tester le pipeline localement
gitlab-runner exec docker test

# Voir les jobs du pipeline
# Via l'interface GitLab web
```

### SonarQube

**Windows (PowerShell) :**
```powershell
# Installer SonarQube Scanner
# Télécharger depuis: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/

# Analyser un projet
sonar-scanner -Dsonar.projectKey=myproject

# Via Docker (si Docker installé)
docker run --rm -v ${PWD}:/usr/src sonarsource/sonar-scanner-cli
```

**Linux/Mac :**
```bash
# Installer SonarQube Scanner
# Linux: sudo apt install sonar-scanner
# Mac: brew install sonar-scanner

# Analyser un projet
sonar-scanner -Dsonar.projectKey=myproject

# Via Docker
docker run --rm -v $(pwd):/usr/src sonarsource/sonar-scanner-cli
```

### Terraform

**Windows (PowerShell) :**
```powershell
# Télécharger Terraform depuis: https://www.terraform.io/downloads

# Initialiser
terraform init

# Planifier
terraform plan

# Appliquer
terraform apply
```

**Linux/Mac :**
```bash
# Installer Terraform
# Linux: https://learn.hashicorp.com/tutorials/terraform/install-cli
# Mac: brew install terraform

# Initialiser
terraform init

# Planifier
terraform plan

# Appliquer
terraform apply
```

### Ansible

**Windows :**
```powershell
# Installer Ansible (via WSL ou pip)
pip install ansible

# Exécuter un playbook
ansible-playbook -i inventory playbook.yml

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml
```

**Linux/Mac :**
```bash
# Installer Ansible
sudo apt install ansible  # Linux
brew install ansible      # Mac

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

### Documentation dans ce projet

- **`docs/pipeline-design.md`** : Design détaillé du pipeline CI/CD
- **`docs/security-practices.md`** : Pratiques de sécurité DevSecOps
- **`docs/alternatives-gratuites.md`** : Tous les services gratuits pour CI/CD
- **`docs/rappels-theoriques/`** : Rappels théoriques avec exercices pratiques
  - `git-avance.md` : Git avancé et workflows
  - `docker-avance.md` : Docker pour CI/CD

### Scripts disponibles

- **`scripts/decrypt.sh`** : Déchiffrer les corrections (après avoir le mot de passe)
- **`scripts/encrypt.sh`** : Chiffrer les corrections (pour l'enseignant)
- **`COMMENT-ACCEDER-AUX-CORRECTIONS.md`** : Guide complet pour accéder aux corrections

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


