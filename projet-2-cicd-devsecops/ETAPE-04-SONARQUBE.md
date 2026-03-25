# Etape 4 : SonarQube — Analyse Statique de Code

> **Objectif** : Installer, configurer et utiliser SonarQube pour analyser la qualite
> et la securite du code de l'application financiere.

---

## Table des Matieres

1. [Installation avec Docker Compose](#1-installation-avec-docker-compose)
2. [Configuration Initiale](#2-configuration-initiale)
3. [Quality Gates et Quality Profiles](#3-quality-gates-et-quality-profiles)
4. [Configuration du Projet](#4-configuration-du-projet)
5. [Integration avec GitLab CI](#5-integration-avec-gitlab-ci)
6. [Alternative Locale](#6-alternative-locale)
7. [Interpreter les Resultats](#7-interpreter-les-resultats)
8. [Security Hotspots](#8-security-hotspots)

---

## 1. Installation avec Docker Compose

### Demarrer SonarQube

```bash
cd sonarqube/
docker compose -f docker-compose-sonarqube.yml up -d
```

Cela demarre :
- **SonarQube** sur le port `9000` (interface web + moteur d'analyse)
- **PostgreSQL** sur le port `5432` (base de donnees pour SonarQube)

### Verifier que ca fonctionne

```bash
# Attendre que SonarQube soit pret (peut prendre 1-2 minutes)
until curl -s http://localhost:9000/api/system/status | grep -q "UP"; do
  echo "SonarQube is starting..."
  sleep 5
done
echo "SonarQube is ready!"
```

### Acceder a l'interface

- URL : **http://localhost:9000**
- Login : `admin`
- Mot de passe : `admin` (vous devrez le changer au premier login)

### Prerequis Systeme

SonarQube necessite au minimum :
- **4 Go de RAM** disponibles
- **Docker** et **Docker Compose** installes
- Le parametre systeme `vm.max_map_count >= 262144` :

```bash
# Linux uniquement (necessaire pour Elasticsearch interne)
sudo sysctl -w vm.max_map_count=262144
# Pour le rendre permanent :
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

---

## 2. Configuration Initiale

### 2.1 Changer le Mot de Passe Admin

1. Connectez-vous avec `admin` / `admin`
2. SonarQube vous demandera de changer le mot de passe
3. Choisissez un mot de passe fort (contexte financier !)

### 2.2 Generer un Token d'Authentification

Le token sera utilise par le scanner (et par GitLab CI) :

1. Allez dans **My Account** (icone profil en haut a droite)
2. Onglet **Security**
3. **Generate Token** :
   - Name : `gitlab-ci-scanner`
   - Type : `Project Analysis Token`
   - Project : (selectionnez votre projet, ou Global si pas encore cree)
4. **Copiez le token** (il ne sera plus affiche)

Format du token : `sqa_xxxxxxxxxxxxxxxxxxxxxxxxxx`

### 2.3 Creer le Projet dans SonarQube

1. Page d'accueil → **Create Project**
2. **Manually**
3. Project key : `finance-app`
4. Display name : `Finance App - DevSecOps`
5. Main branch : `main`
6. Choisissez **Locally** pour la methode d'analyse

---

## 3. Quality Gates et Quality Profiles

### 3.1 Quality Gate

Un **Quality Gate** definit les criteres de reussite de l'analyse. Si un critere echoue,
le pipeline doit etre bloque.

#### Quality Gate par defaut ("Sonar way")

| Condition | Operateur | Valeur |
|---|---|---|
| Coverage on New Code | >= | 80% |
| Duplicated Lines (%) on New Code | <= | 3% |
| Maintainability Rating | = | A |
| Reliability Rating | = | A |
| Security Rating | = | A |
| Security Hotspots Reviewed | = | 100% |

#### Creer un Quality Gate personnalise (recommande pour le projet)

1. Allez dans **Quality Gates** (menu du haut)
2. **Create** → Name : `DevSecOps Finance`
3. Ajoutez les conditions :

| Condition | Operateur | Valeur | Justification |
|---|---|---|---|
| Coverage | >= | 70% | Adapte a un projet pedagogique |
| Duplicated Lines | <= | 5% | Tolerance pedagogique |
| Bugs | = | 0 | Zero bug en finance ! |
| Vulnerabilities | = | 0 | Zero vulnerabilite ! |
| Security Rating | = | A | Rating maximum |
| Code Smells | <= | 10 | Tolerance raisonnable |

4. **Set as Default** si vous voulez l'appliquer a tous les projets

### 3.2 Quality Profile

Un **Quality Profile** definit les regles d'analyse pour un langage.

1. Allez dans **Quality Profiles** (menu du haut)
2. Le profil **"Sonar way"** pour Python est active par defaut
3. Il contient environ 400 regles couvrant :
   - Conventions de code (PEP 8)
   - Bugs potentiels
   - Vulnerabilites de securite
   - Performances
   - Maintenabilite

Pour le personnaliser :
1. **Copy** le profil "Sonar way"
2. Renommez-le : `DevSecOps Python`
3. Activez/desactivez des regles selon vos besoins

---

## 4. Configuration du Projet

### 4.1 Fichier `sonar-project.properties`

Ce fichier, place a la racine du projet, configure le scanner :

```properties
# Identification du projet
sonar.projectKey=finance-app
sonar.projectName=Finance App - DevSecOps
sonar.projectVersion=1.0.0

# Sources a analyser
sonar.sources=app/
sonar.tests=app/tests/
sonar.python.coverage.reportPaths=app/coverage.xml

# Exclusions
sonar.exclusions=**/venv/**,**/__pycache__/**,**/migrations/**
sonar.test.exclusions=**/test_*.py

# Encodage
sonar.sourceEncoding=UTF-8

# Langue
sonar.language=py
```

### 4.2 Explication de Chaque Propriete

| Propriete | Role |
|---|---|
| `sonar.projectKey` | Identifiant unique du projet dans SonarQube |
| `sonar.sources` | Repertoire contenant le code source a analyser |
| `sonar.tests` | Repertoire des tests (exclu de l'analyse de code) |
| `sonar.python.coverage.reportPaths` | Chemin vers le rapport de couverture (genere par pytest) |
| `sonar.exclusions` | Fichiers/dossiers a exclure de l'analyse |
| `sonar.qualitygate.wait` | (CLI) Attend le resultat du Quality Gate |

---

## 5. Integration avec GitLab CI

### 5.1 Variables a Configurer dans GitLab

Dans **Settings > CI/CD > Variables** :

| Variable | Valeur | Masquee |
|---|---|---|
| `SONAR_HOST_URL` | `http://sonarqube:9000` | Non |
| `SONAR_TOKEN` | `sqa_xxxxx...` | **Oui** |

### 5.2 Job dans `.gitlab-ci.yml`

Le stage `quality` du pipeline execute le scanner SonarQube :

```yaml
sonarqube-analysis:
  stage: quality
  image:
    name: sonarsource/sonar-scanner-cli:5
    entrypoint: [""]
  script:
    - sonar-scanner
      -Dsonar.projectKey=finance-app
      -Dsonar.sources=app/
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
      -Dsonar.python.coverage.reportPaths=app/coverage.xml
      -Dsonar.qualitygate.wait=true
  dependencies:
    - unit-tests
```

### 5.3 Flux de Donnees

```
pytest (stage test)
    │
    ▼
coverage.xml (artifact)
    │
    ▼
sonar-scanner (stage quality)
    │ Envoie le code + coverage.xml
    ▼
SonarQube Server
    │ Analyse → Quality Gate
    ▼
Resultat : PASSED ou FAILED
    │
    ▼
Pipeline continue ou s'arrete
```

---

## 6. Alternative Locale

### 6.1 Installer sonar-scanner en Local

```bash
# Option 1 : Via Docker (recommande)
docker run --rm \
  -e SONAR_HOST_URL="http://host.docker.internal:9000" \
  -e SONAR_TOKEN="votre-token" \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli:5

# Option 2 : Installation native
# Telecharger depuis https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-*.zip
export PATH=$PATH:$(pwd)/sonar-scanner-*/bin
```

### 6.2 Lancer une Analyse Locale

```bash
# 1. Demarrer SonarQube
cd sonarqube/
docker compose -f docker-compose-sonarqube.yml up -d

# 2. Attendre qu'il soit pret
sleep 60  # ou utiliser la boucle until ci-dessus

# 3. Generer le rapport de couverture
cd ../app/
pytest tests/ --cov=. --cov-report=xml:coverage.xml

# 4. Lancer le scan
cd ..
sonar-scanner \
  -Dsonar.projectKey=finance-app \
  -Dsonar.sources=app/ \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=votre-token \
  -Dsonar.python.coverage.reportPaths=app/coverage.xml

# 5. Voir les resultats
echo "Resultats disponibles sur http://localhost:9000/dashboard?id=finance-app"
```

---

## 7. Interpreter les Resultats

### 7.1 Dashboard Principal

Apres une analyse, le dashboard affiche :

```
┌─────────────────────────────────────────────────────────────┐
│  FINANCE APP - DevSecOps                                    │
│                                                             │
│  Quality Gate: ✅ PASSED                                    │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Bugs: 0 (A)  │  Vulns: 0 (A)  │  Smells: 3 (A)   │  │
│  │  Coverage: 85% │  Duplications: 1.2%                │  │
│  │  Hotspots: 0 to review                              │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 7.2 Les Metriques Expliquees

| Metrique | Ce que ca mesure | Objectif |
|---|---|---|
| **Bugs** | Erreurs qui causeront un dysfonctionnement | 0 |
| **Vulnerabilities** | Failles exploitables par un attaquant | 0 |
| **Code Smells** | Code qui fonctionne mais mal ecrit | Le moins possible |
| **Coverage** | % du code couvert par les tests | >= 70-80% |
| **Duplications** | % de code duplique | <= 3-5% |
| **Security Hotspots** | Points a verifier manuellement | Tous revus |

### 7.3 Les Ratings (A → E)

| Rating | Signification | Action |
|---|---|---|
| **A** | Excellent | Rien a faire |
| **B** | Bon | Ameliorations mineures |
| **C** | Moyen | Attention requise |
| **D** | Mauvais | Correction necessaire |
| **E** | Critique | Correction urgente |

### 7.4 Exemples de Problemes Detectes en Python

| Type | Exemple | Severite |
|---|---|---|
| Bug | `if x = 5:` (assignation au lieu de comparaison) | Critical |
| Vulnerability | `eval(user_input)` | Blocker |
| Vulnerability | SQL injection : `"SELECT * FROM users WHERE id=" + user_id` | Blocker |
| Code Smell | Fonction de 200 lignes | Major |
| Code Smell | Variable non utilisee | Minor |
| Security Hotspot | `import hashlib` → verifier l'algorithme utilise | Review |

---

## 8. Security Hotspots

### 8.1 Qu'est-ce qu'un Security Hotspot ?

Un **Security Hotspot** est un morceau de code qui **pourrait** poser un probleme de
securite, mais qui necessite une **verification humaine** pour le confirmer.

Contrairement aux vulnerabilites (qui sont des problemes confirmes), les hotspots
demandent une decision :
- **Safe** : Le code est correct et securise
- **Fixed** : Le code a ete corrige
- **To Review** : A examiner

### 8.2 Exemples dans un Contexte Financier

| Code detecte | Pourquoi c'est un hotspot | Decision |
|---|---|---|
| `import random` | `random` n'est pas cryptographiquement sur | Safe si pas utilise pour la securite |
| `app.run(debug=True)` | Debug en production expose des infos | Fixed : `debug=False` en prod |
| `open("file.log")` | Ecriture de fichier, risque de path traversal | Safe si chemin controle |
| `json.loads(request.data)` | Deserialisation de donnees externes | Safe si validation en aval |

### 8.3 Processus de Revue

1. Allez dans l'onglet **Security Hotspots** du projet
2. Pour chaque hotspot :
   - Lisez le code concerne
   - Lisez la description du risque
   - Decidez : **Safe**, **Fixed**, ou laissez **To Review**
3. Le Quality Gate exige que 100% des hotspots soient revus

---

## Fichiers a Examiner

- `sonarqube/docker-compose-sonarqube.yml` — Installation SonarQube
- `sonarqube/sonar-project.properties` — Configuration du scanner
- `.gitlab-ci.yml` — Stage `quality` du pipeline
