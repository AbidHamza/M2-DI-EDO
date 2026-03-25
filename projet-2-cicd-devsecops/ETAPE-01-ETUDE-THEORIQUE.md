# Etape 1 : Etude Theorique DevSecOps (30 points)

> **Objectif** : Comprendre les fondements du DevSecOps, les outils utilises, et les enjeux
> de securite dans un contexte d'application financiere.

---

## Table des Matieres

1. [DevSecOps : Definition et Principes](#1-devsecops--definition-et-principes)
2. [Comparaison DevOps vs DevSecOps](#2-comparaison-devops-vs-devsecops)
3. [GitLab CI : Architecture et Fonctionnement](#3-gitlab-ci--architecture-et-fonctionnement)
4. [SonarQube : Analyse Statique de Code](#4-sonarqube--analyse-statique-de-code)
5. [Ansible : Deploiement Automatise](#5-ansible--deploiement-automatise)
6. [Terraform : Infrastructure as Code](#6-terraform--infrastructure-as-code)
7. [Enjeux de Securite dans un Contexte Financier](#7-enjeux-de-securite-dans-un-contexte-financier)
8. [Conseils pour le Rapport](#8-conseils-pour-le-rapport)

---

## 1. DevSecOps : Definition et Principes

### 1.1 Definition

**DevSecOps** = **Dev**elopment + **Sec**urity + **Op**eration**s**

Le DevSecOps est une evolution du DevOps qui **integre la securite a chaque etape du cycle
de vie logiciel**, et non plus comme une verification finale. La securite n'est plus un
"gate" en fin de processus, mais un **processus continu** integre dans le pipeline.

### 1.2 Le Principe du "Shift-Left Security"

```
Approche Traditionnelle :
Plan → Code → Build → Test → Release → Deploy → ←── Security (trop tard !)

Approche Shift-Left (DevSecOps) :
Plan → Code → Build → Test → Release → Deploy
  ↑       ↑       ↑       ↑       ↑        ↑
  Sec     Sec     Sec     Sec     Sec      Sec   ← Securite partout !
```

**Pourquoi "Shift-Left" ?** Parce qu'on deplace ("shift") les controles de securite vers
la gauche du pipeline (c'est-a-dire plus tot dans le cycle). Plus une vulnerabilite est
detectee tot, moins elle coute cher a corriger.

| Moment de detection | Cout relatif de correction |
|---|---|
| Conception | x1 |
| Developpement | x6 |
| Tests | x15 |
| Production | x100 |

### 1.3 Les 5 Piliers du DevSecOps

1. **Automatisation** : Chaque controle de securite est automatise dans le pipeline
2. **Continuite** : La securite s'execute a chaque commit, pas une fois par trimestre
3. **Collaboration** : Dev, Sec et Ops travaillent ensemble (pas en silos)
4. **Feedback rapide** : Le developpeur est informe immediatement d'un probleme
5. **Responsabilite partagee** : La securite est l'affaire de tous, pas d'une seule equipe

### 1.4 Le Cycle DevSecOps

```
        ┌────────────────────────────────────────┐
        │           CYCLE DevSecOps              │
        │                                        │
        │    Plan ──→ Code ──→ Build ──→ Test   │
        │     ↑                            │     │
        │     │    SECURITE CONTINUE       │     │
        │     │    a chaque etape          ↓     │
        │  Monitor ←── Deploy ←── Release       │
        │                                        │
        └────────────────────────────────────────┘
```

---

## 2. Comparaison DevOps vs DevSecOps

### 2.1 Tableau Comparatif Detaille

| Critere | DevOps | DevSecOps |
|---|---|---|
| **Objectif principal** | Livraison rapide et fiable | Livraison rapide, fiable ET securisee |
| **Place de la securite** | Etape separee, souvent en fin de cycle | Integree a chaque etape du pipeline |
| **Responsabilite securite** | Equipe securite dediee | Responsabilite partagee (tous) |
| **Moment des tests secu** | Avant la mise en production | A chaque commit (continu) |
| **Automatisation secu** | Manuelle ou partielle | Totalement automatisee |
| **Feedback securite** | Jours/semaines apres le dev | Secondes/minutes (dans le pipeline) |
| **Outils typiques** | Jenkins, GitLab CI, Docker, K8s | Idem + SonarQube, Trivy, Bandit, OWASP |
| **Culture** | Collaboration Dev + Ops | Collaboration Dev + Sec + Ops |
| **Cout de correction** | Eleve (detection tardive) | Faible (detection precoce, Shift-Left) |
| **Conformite** | Verifiee periodiquement | Verifiee en continu, automatisee |
| **Audit trail** | Optionnel | Obligatoire et automatise |
| **Gestion des secrets** | Variable (parfois en dur dans le code) | Stricte (vaults, variables masquees) |

### 2.2 Ce que DevSecOps Ajoute Concretement au Pipeline

```
Pipeline DevOps classique :
  Test → Build → Deploy

Pipeline DevSecOps :
  Test → Analyse Statique (SonarQube) → Scan Securite (Bandit/Trivy) → Build → Deploy
         ↑ Quality Gate                  ↑ Vulnerabilites                ↑ Image scan
```

**Ajouts concrets** :
- **SAST** (Static Application Security Testing) : SonarQube, Bandit
- **SCA** (Software Composition Analysis) : OWASP Dependency-Check
- **Container Scanning** : Trivy scanne l'image Docker
- **Secret Detection** : GitLeaks, detect-secrets
- **DAST** (Dynamic Application Security Testing) : OWASP ZAP (post-deploiement)

---

## 3. GitLab CI : Architecture et Fonctionnement

### 3.1 Architecture de GitLab CI

```
┌──────────────────────────────────────────────────┐
│                   GITLAB SERVER                   │
│                                                    │
│  ┌──────────┐   ┌──────────────────────────┐     │
│  │   Repo   │──→│    .gitlab-ci.yml        │     │
│  │   Git    │   │    (definition pipeline) │     │
│  └──────────┘   └──────────┬───────────────┘     │
│                             │                      │
│                             ▼                      │
│                  ┌─────────────────┐               │
│                  │   PIPELINE      │               │
│                  │                 │               │
│                  │  Stage 1: test  │               │
│                  │  Stage 2: qual  │               │
│                  │  Stage 3: secu  │               │
│                  │  Stage 4: build │               │
│                  │  Stage 5: deploy│               │
│                  └────────┬────────┘               │
│                           │                        │
└───────────────────────────┼────────────────────────┘
                            │
                            ▼
                  ┌─────────────────┐
                  │   GITLAB RUNNER │  (execute les jobs)
                  │                 │
                  │  Docker executor│
                  │  Shell executor │
                  │  K8s executor   │
                  └─────────────────┘
```

### 3.2 Concepts Cles

| Concept | Description | Exemple |
|---|---|---|
| **Pipeline** | Ensemble ordonne de stages declenche par un evenement | Push, MR, schedule |
| **Stage** | Groupe de jobs qui s'executent en parallele | `test`, `build`, `deploy` |
| **Job** | Unite de travail executee par un runner | `pytest`, `docker build` |
| **Runner** | Agent qui execute les jobs | Serveur dedie, Docker, K8s |
| **Artifact** | Fichier produit par un job, transmis au suivant | `coverage.xml`, `report.html` |
| **Variable** | Parametre injectable dans le pipeline | `$SONAR_TOKEN`, `$DOCKER_PASS` |
| **Cache** | Fichiers conserves entre les pipelines | `node_modules/`, `.pip/` |
| **Rules** | Conditions d'execution d'un job | `if: $CI_COMMIT_BRANCH == "main"` |

### 3.3 Structure d'un `.gitlab-ci.yml`

```yaml
# Definition des stages (ordre d'execution)
stages:
  - test
  - quality
  - security
  - build
  - deploy

# Variables globales
variables:
  PYTHON_VERSION: "3.11"

# Job dans le stage "test"
unit-tests:
  stage: test
  image: python:3.11-slim          # Image Docker du job
  script:                           # Commandes a executer
    - pip install -r requirements.txt
    - pytest tests/ --cov
  artifacts:                        # Fichiers a conserver
    reports:
      junit: report.xml
    paths:
      - coverage.xml
  rules:                            # Conditions d'execution
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"
```

### 3.4 Les Runners GitLab

Un **Runner** est un agent qui execute les jobs du pipeline. Il peut fonctionner avec
differents **executors** :

- **Docker executor** (recommande) : Chaque job tourne dans un conteneur isole
- **Shell executor** : Execute directement sur la machine hote
- **Kubernetes executor** : Execute dans des pods K8s

**Registration d'un Runner** :
```bash
gitlab-runner register \
  --url https://gitlab.example.com \
  --registration-token $REGISTRATION_TOKEN \
  --executor docker \
  --docker-image python:3.11-slim
```

---

## 4. SonarQube : Analyse Statique de Code

### 4.1 Qu'est-ce que SonarQube ?

SonarQube est une plateforme d'**analyse statique de code** qui detecte automatiquement :
- Les **bugs** potentiels
- Les **vulnerabilites** de securite
- Les **code smells** (mauvaises pratiques)
- Les **duplications** de code
- Le **taux de couverture** des tests

### 4.2 Architecture

```
┌──────────────────────────────────────────────┐
│              SONARQUBE SERVER                 │
│                                              │
│  ┌─────────────┐    ┌───────────────────┐   │
│  │   Web UI    │    │  Compute Engine   │   │
│  │  (port 9000)│    │  (analyse code)   │   │
│  └─────────────┘    └───────────────────┘   │
│         │                    │               │
│         ▼                    ▼               │
│  ┌──────────────────────────────────────┐   │
│  │          PostgreSQL Database          │   │
│  │     (resultats, metriques, config)    │   │
│  └──────────────────────────────────────┘   │
└──────────────────────────────────────────────┘
         ▲
         │ Envoi du rapport
         │
┌──────────────────┐
│  SONAR-SCANNER   │  (execute dans le pipeline CI)
│                  │
│  Analyse le code │
│  source          │
└──────────────────┘
```

### 4.3 Concepts Cles

#### Quality Gate (Seuil de Qualite)

Un **Quality Gate** est un ensemble de conditions que le code doit respecter pour passer :

| Metrique | Seuil par defaut | Description |
|---|---|---|
| Couverture | >= 80% | Pourcentage de code couvert par les tests |
| Duplications | <= 3% | Code duplique |
| Bugs | 0 (niveau A) | Bugs potentiels |
| Vulnerabilites | 0 (niveau A) | Failles de securite |
| Code Smells | Niveau A | Mauvaises pratiques |
| Security Hotspots | Tous revus | Points a verifier manuellement |

Si le Quality Gate echoue, le pipeline **doit s'arreter** (principe DevSecOps).

#### Quality Profile

Un **Quality Profile** definit les regles d'analyse appliquees a un langage :
- Python : ~400 regles (PEP8, securite, performances)
- Possibilite de personnaliser : activer/desactiver des regles
- Heritage entre profils (ex: "Strict" herite de "Default")

#### Types de Problemes

| Type | Icone | Description | Exemple |
|---|---|---|---|
| **Bug** | B | Erreur qui causera un dysfonctionnement | Division par zero, NullPointer |
| **Vulnerability** | V | Faille exploitable par un attaquant | SQL injection, XSS |
| **Code Smell** | CS | Code qui fonctionne mais mal ecrit | Fonction trop longue, variable inutilisee |
| **Security Hotspot** | SH | Code a verifier manuellement | Utilisation de crypto, acces fichier |

#### Severites

| Severite | Impact |
|---|---|
| **Blocker** | Bug critique, peut causer un crash en production |
| **Critical** | Vulnerabilite grave ou bug majeur |
| **Major** | Probleme significatif a corriger |
| **Minor** | Amelioration souhaitable |
| **Info** | Suggestion cosmetique |

---

## 5. Ansible : Deploiement Automatise

### 5.1 Qu'est-ce qu'Ansible ?

Ansible est un outil d'**automatisation IT** qui permet de :
- **Configurer** des serveurs (installer packages, configurer services)
- **Deployer** des applications (pull image, start container, health check)
- **Orchestrer** des operations complexes (rolling update, blue-green)

### 5.2 Pourquoi Ansible dans un Pipeline CI/CD ?

```
Pipeline CI/CD :
  ... → Build (image Docker) → Deploy (Ansible) → ...
                                      │
                                      ▼
                              ┌───────────────┐
                              │ Ansible fait : │
                              │ 1. Pull image  │
                              │ 2. Stop ancien │
                              │ 3. Start new   │
                              │ 4. Health check│
                              │ 5. Rollback ?  │
                              └───────────────┘
```

### 5.3 Concepts Cles

| Concept | Description | Fichier |
|---|---|---|
| **Inventory** | Liste des serveurs cibles | `inventory/dev.ini` |
| **Playbook** | Scenario d'automatisation | `playbook.yml` |
| **Role** | Module reutilisable (taches + templates + handlers) | `roles/deploy/` |
| **Task** | Action unitaire (ex: installer un package) | `tasks/main.yml` |
| **Handler** | Action declenchee par un changement | Restart service |
| **Template** | Fichier Jinja2 avec variables | `docker-compose.yml.j2` |
| **Vault** | Chiffrement des secrets | `ansible-vault encrypt` |

### 5.4 Ansible vs Scripts Shell

| Critere | Script Shell | Ansible |
|---|---|---|
| **Idempotence** | Non (risque de re-execution) | Oui (etat desire) |
| **Multi-serveurs** | Boucle manuelle | Natif (inventory) |
| **Gestion d'erreurs** | `set -e` basique | Handlers, rescue, retry |
| **Secrets** | Variables d'environnement | Ansible Vault (chiffre) |
| **Templates** | `sed`/`envsubst` | Jinja2 natif |
| **Lisibilite** | Variable | YAML structure |

---

## 6. Terraform : Infrastructure as Code

### 6.1 Qu'est-ce que Terraform ?

Terraform est un outil d'**Infrastructure as Code (IaC)** qui permet de :
- **Declarer** l'infrastructure souhaitee dans des fichiers `.tf`
- **Planifier** les changements avant de les appliquer (`plan`)
- **Provisionner** automatiquement l'infrastructure (`apply`)
- **Detruire** proprement quand ce n'est plus necessaire (`destroy`)

### 6.2 Le Workflow Terraform

```
   Ecrire le code         Previsualiser         Appliquer
   ┌──────────┐         ┌──────────────┐       ┌──────────┐
   │  .tf     │──────→  │ terraform    │─────→ │ terraform│
   │  files   │         │ plan         │       │ apply    │
   └──────────┘         └──────────────┘       └──────────┘
                         "Voici ce qui                │
                          va changer"                 │
                                                      ▼
                                              ┌──────────────┐
                                              │ Infrastructure│
                                              │ provisionnee  │
                                              └──────────────┘
                                                      │
                                              ┌──────────────┐
                                              │ terraform    │
                                              │ destroy      │
                                              └──────────────┘
                                              "Tout est supprime
                                               proprement"
```

### 6.3 Concepts Cles

| Concept | Description | Exemple |
|---|---|---|
| **Provider** | Plugin pour interagir avec une plateforme | `docker`, `aws`, `azurerm` |
| **Resource** | Element d'infrastructure a creer | `docker_container`, `aws_instance` |
| **Variable** | Parametre configurable | `app_port = 5000` |
| **Output** | Valeur exposee apres `apply` | URL de l'application |
| **State** | Etat actuel de l'infrastructure | `terraform.tfstate` |
| **Module** | Groupe reutilisable de resources | Module "network", module "app" |
| **tfvars** | Fichier de variables par environnement | `dev.tfvars`, `prod.tfvars` |

### 6.4 Terraform vs Docker Compose

| Critere | Docker Compose | Terraform |
|---|---|---|
| **Scope** | Conteneurs sur une machine | Toute infrastructure (cloud, VM, conteneurs) |
| **State management** | Non (recree tout) | Oui (fichier state, gestion des diffs) |
| **Multi-environnement** | Fichiers `.env` | Fichiers `.tfvars` par env |
| **Planification** | Non | `terraform plan` avant d'appliquer |
| **Providers** | Docker uniquement | AWS, Azure, GCP, Docker, K8s... |
| **Idempotence** | Partielle | Complete (etat desire) |

### 6.5 Pourquoi Terraform dans ce Projet ?

Dans notre contexte, Terraform est utilise pour :
1. **Provisionner les conteneurs Docker** de maniere declarative
2. **Gerer les 3 environnements** (dev/staging/prod) avec des tfvars differents
3. **Garantir la reproductibilite** : meme code = meme infrastructure
4. **Documenter l'infrastructure** : les fichiers `.tf` SONT la documentation

---

## 7. Enjeux de Securite dans un Contexte Financier

### 7.1 Pourquoi la Finance est un Contexte Critique ?

Une application financiere manipule des **donnees sensibles** :
- Informations personnelles (identite, adresse)
- Donnees bancaires (IBAN, numeros de carte)
- Transactions financieres (montants, historique)
- Soldes de comptes

Une faille de securite peut entrainer :
- **Vol de donnees** → amendes RGPD (jusqu'a 4% du CA mondial)
- **Fraude financiere** → pertes directes
- **Perte de confiance** → impact business irreversible
- **Non-conformite** → sanctions legales

### 7.2 Reglementations Applicables

#### RGPD (Reglement General sur la Protection des Donnees)

| Exigence RGPD | Implementation DevSecOps |
|---|---|
| Minimisation des donnees | Ne collecter que le necessaire |
| Chiffrement | TLS, chiffrement at-rest |
| Droit a l'effacement | API de suppression, traces d'audit |
| Notification de breach | Monitoring + alerting (Prometheus/Grafana) |
| Privacy by Design | Securite integree dans le pipeline |

#### PCI-DSS (Payment Card Industry Data Security Standard)

| Exigence PCI-DSS | Implementation DevSecOps |
|---|---|
| Firewall/segmentation | Reseaux Docker isoles (Terraform) |
| Pas de credentials par defaut | Ansible Vault, GitLab CI variables |
| Chiffrement des transmissions | TLS obligatoire |
| Antivirus / Scan vulnerabilites | Trivy, Bandit dans le pipeline |
| Controle d'acces | RBAC, principe du moindre privilege |
| Logging et monitoring | Prometheus + Grafana + logs structures |
| Tests de securite reguliers | Pipeline CI/CD a chaque commit |

### 7.3 Gestion des Secrets

**Regle d'or : JAMAIS de secret dans le code source.**

| Type de secret | Ou le stocker | Outil |
|---|---|---|
| Token API SonarQube | Variables CI/CD (masquees) | GitLab CI |
| Mots de passe serveurs | Vault chiffre | Ansible Vault |
| Credentials Docker Registry | Variables CI/CD (protegees) | GitLab CI |
| Variables sensibles Terraform | Variables marked sensitive | Terraform |
| Cles SSH | Deploy Keys | GitLab |

### 7.4 Audit Trail (Tracabilite)

Chaque action doit etre tracee :

```
[2026-03-25 10:30:00] PIPELINE #42 started by user:jean
[2026-03-25 10:30:15] STAGE test: 12 tests PASSED
[2026-03-25 10:30:45] STAGE quality: SonarQube PASSED (0 bugs, 0 vulns)
[2026-03-25 10:31:00] STAGE security: Bandit PASSED (0 high severity)
[2026-03-25 10:31:30] STAGE security: Trivy PASSED (0 critical CVE)
[2026-03-25 10:32:00] STAGE build: Image finance-app:v1.2.3 pushed
[2026-03-25 10:33:00] STAGE deploy: Deployed to prod (Ansible)
[2026-03-25 10:33:15] HEALTH CHECK: /health returned 200 OK
```

### 7.5 Defense en Profondeur

```
┌─────────────────────────────────────────────────┐
│  Couche 1 : CODE (Shift-Left)                   │
│  → SonarQube, Bandit, revue de code            │
├─────────────────────────────────────────────────┤
│  Couche 2 : IMAGE (Build)                       │
│  → Trivy, multi-stage Docker, non-root user    │
├─────────────────────────────────────────────────┤
│  Couche 3 : DEPLOIEMENT (Runtime)               │
│  → Ansible Vault, variables masquees, TLS      │
├─────────────────────────────────────────────────┤
│  Couche 4 : INFRASTRUCTURE (Network)            │
│  → Terraform, reseaux isoles, firewall rules   │
├─────────────────────────────────────────────────┤
│  Couche 5 : MONITORING (Detection)              │
│  → Prometheus alertes, Grafana dashboards      │
└─────────────────────────────────────────────────┘
```

---

## 8. Conseils pour le Rapport (Partie 1)

### Structure recommandee pour les 30 points

1. **Introduction au DevSecOps** (5 pts)
   - Definition claire avec vos propres mots
   - Principe du Shift-Left Security avec schema
   - Pourquoi c'est une evolution necessaire du DevOps

2. **Comparaison DevOps vs DevSecOps** (5 pts)
   - Tableau comparatif detaille
   - Exemples concrets pour chaque difference
   - Schema montrant l'integration de la securite

3. **Presentation des Outils** (10 pts)
   - GitLab CI : architecture, runners, pipelines (avec schema)
   - SonarQube : quality gates, metriques, integration CI
   - Ansible : playbooks, roles, vault, deploiement automatise
   - Terraform : IaC, workflow plan/apply, multi-environnement

4. **Enjeux de Securite Financiere** (10 pts)
   - RGPD et PCI-DSS : exigences et implementation
   - Gestion des secrets (tableau des outils)
   - Defense en profondeur (schema des couches)
   - Audit trail et tracabilite

### Erreurs a Eviter

- Ne pas se contenter de definitions Wikipedia → donner des exemples concrets
- Ne pas oublier les schemas → les correcteurs aiment les visuels
- Ne pas melanger theorie et pratique → la partie 1 est theorique
- Ne pas ignorer le contexte financier → c'est specifique au sujet
- Ne pas copier-coller → reformuler avec vos propres mots

### Vocabulaire Cle a Maitriser

- **Shift-Left** : Deplacer les controles de securite plus tot dans le cycle
- **SAST** : Static Application Security Testing (analyse du code source)
- **DAST** : Dynamic Application Security Testing (test de l'application en cours)
- **SCA** : Software Composition Analysis (analyse des dependances)
- **Quality Gate** : Seuil de qualite que le code doit respecter
- **IaC** : Infrastructure as Code (infrastructure declaree dans du code)
- **Idempotence** : Appliquer la meme operation N fois donne le meme resultat
- **Immutable Infrastructure** : On ne modifie pas, on remplace
