# Etape 3 : Pipeline GitLab CI/CD (Partie 2 & 3)

> **Objectif** : Configurer un pipeline CI/CD complet avec 5 stages :
> test → quality → security → build → deploy

---

## Table des Matieres

1. [Vue d'Ensemble du Pipeline](#1-vue-densemble-du-pipeline)
2. [Stage 1 : Test](#2-stage-1--test)
3. [Stage 2 : Quality (SonarQube)](#3-stage-2--quality-sonarqube)
4. [Stage 3 : Security (Bandit + Trivy)](#4-stage-3--security-bandit--trivy)
5. [Stage 4 : Build (Docker)](#5-stage-4--build-docker)
6. [Stage 5 : Deploy (Ansible)](#6-stage-5--deploy-ansible)
7. [Variables et Secrets](#7-variables-et-secrets)
8. [Alternative Locale](#8-alternative-locale)

---

## 1. Vue d'Ensemble du Pipeline

### Schema du Pipeline

```
  ┌────────┐    ┌─────────┐    ┌──────────┐    ┌───────┐    ┌────────┐
  │  TEST  │───→│ QUALITY │───→│ SECURITY │───→│ BUILD │───→│ DEPLOY │
  │        │    │         │    │          │    │       │    │        │
  │ pytest │    │ Sonar-  │    │ Bandit   │    │Docker │    │Ansible │
  │ cover  │    │ Qube    │    │ Trivy    │    │ build │    │play-   │
  │        │    │         │    │          │    │ push  │    │ book   │
  └────────┘    └─────────┘    └──────────┘    └───────┘    └────────┘
       │              │              │              │             │
   coverage.xml   sonar report   bandit.json   image:tag    deployed!
   report.xml     quality gate   trivy.json                health OK
```

### Declenchement du Pipeline

Le pipeline se declenche automatiquement sur :
- **Chaque push** sur n'importe quelle branche
- **Chaque Merge Request**
- Le stage `deploy` ne s'execute que sur la branche `main`

---

## 2. Stage 1 : Test

### Que fait ce stage ?

Execution des **tests unitaires** avec `pytest` et generation du **rapport de couverture**.

### Configuration dans `.gitlab-ci.yml`

```yaml
unit-tests:
  stage: test
  image: python:3.11-slim
  before_script:
    - pip install -r app/requirements.txt
  script:
    - cd app
    - pytest tests/ -v --cov=. --cov-report=xml:coverage.xml --junitxml=report.xml
  artifacts:
    when: always
    reports:
      junit: app/report.xml
      coverage_report:
        coverage_format: cobertura
        path: app/coverage.xml
    paths:
      - app/coverage.xml
      - app/report.xml
    expire_in: 7 days
  coverage: '/TOTAL.*\s+(\d+)%/'
```

### Explication Detaillee

| Element | Explication |
|---|---|
| `image: python:3.11-slim` | Image Docker legere avec Python 3.11 |
| `before_script` | Installe les dependances avant les tests |
| `pytest -v` | Mode verbose : affiche chaque test |
| `--cov=.` | Active la mesure de couverture |
| `--cov-report=xml` | Genere un rapport XML pour SonarQube et GitLab |
| `--junitxml=report.xml` | Rapport JUnit visible dans l'UI GitLab |
| `artifacts.reports.junit` | GitLab affiche les resultats dans l'onglet Tests |
| `coverage` | Regex pour extraire le % de couverture dans les logs |

### Alternative locale

```bash
cd app/
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
pytest tests/ -v --cov=. --cov-report=xml:coverage.xml --cov-report=term
```

---

## 3. Stage 2 : Quality (SonarQube)

### Que fait ce stage ?

Envoie le code a **SonarQube** pour analyse statique : bugs, vulnerabilites, code smells,
couverture, duplications.

### Configuration dans `.gitlab-ci.yml`

```yaml
sonarqube-analysis:
  stage: quality
  image:
    name: sonarsource/sonar-scanner-cli:5
    entrypoint: [""]
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script:
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_NAME}
      -Dsonar.sources=app/
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
      -Dsonar.python.coverage.reportPaths=app/coverage.xml
      -Dsonar.qualitygate.wait=true
  allow_failure: false
  dependencies:
    - unit-tests
```

### Explication Detaillee

| Element | Explication |
|---|---|
| `sonarsource/sonar-scanner-cli:5` | Image officielle du scanner SonarQube |
| `GIT_DEPTH: "0"` | Clone complet pour l'analyse des blames |
| `SONAR_HOST_URL` | URL du serveur SonarQube (variable CI/CD) |
| `SONAR_TOKEN` | Token d'authentification (variable CI/CD masquee) |
| `sonar.qualitygate.wait=true` | Attend le resultat du Quality Gate |
| `allow_failure: false` | Si le Quality Gate echoue, le pipeline echoue |
| `dependencies: [unit-tests]` | Recupere `coverage.xml` du stage precedent |

### Alternative locale

```bash
# Demarrer SonarQube (voir ETAPE-04)
cd sonarqube && docker compose -f docker-compose-sonarqube.yml up -d

# Scanner le code
sonar-scanner \
  -Dsonar.projectKey=finance-app \
  -Dsonar.sources=app/ \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=votre-token \
  -Dsonar.python.coverage.reportPaths=app/coverage.xml
```

---

## 4. Stage 3 : Security (Bandit + Trivy)

### Que fait ce stage ?

Deux jobs de securite en parallele :
- **Bandit** : analyse statique de securite du code Python (SAST)
- **Trivy** : scan de vulnerabilites de l'image Docker (Container Scanning)

### Configuration Bandit

```yaml
bandit-sast:
  stage: security
  image: python:3.11-slim
  before_script:
    - pip install bandit
  script:
    - bandit -r app/ -f json -o bandit-report.json --severity-level medium || true
    - bandit -r app/ -f screen --severity-level medium
  artifacts:
    paths:
      - bandit-report.json
    expire_in: 7 days
    when: always
  allow_failure: false
```

### Configuration Trivy

```yaml
trivy-scan:
  stage: security
  image:
    name: aquasec/trivy:latest
    entrypoint: [""]
  script:
    - trivy fs --severity HIGH,CRITICAL --exit-code 1 --format json -o trivy-report.json app/
    - trivy fs --severity HIGH,CRITICAL --exit-code 0 --format table app/
  artifacts:
    paths:
      - trivy-report.json
    expire_in: 7 days
    when: always
  allow_failure: true
```

### Explication Detaillee

| Element | Explication |
|---|---|
| **Bandit** | Outil de securite Python officiel, detecte SQL injection, exec(), eval()... |
| `--severity-level medium` | Ne remonte que les problemes Medium et au-dessus |
| `-f json` | Rapport JSON pour archivage |
| `-f screen` | Affichage lisible dans les logs |
| **Trivy** | Scanner de vulnerabilites (images Docker, fichiers, dependances) |
| `--severity HIGH,CRITICAL` | Ne bloque que sur les vulns graves |
| `--exit-code 1` | Fait echouer le job si des vulns sont trouvees |
| `allow_failure: true` (Trivy) | Le scan d'image ne bloque pas (informatif) |

### Alternative locale

```bash
# Bandit
pip install bandit
bandit -r app/ -f screen --severity-level medium

# Trivy (scanner les fichiers)
docker run --rm -v $(pwd):/project aquasec/trivy:latest fs /project/app/
```

---

## 5. Stage 4 : Build (Docker)

### Que fait ce stage ?

Construit l'image Docker de l'application et la pousse vers le **GitLab Container Registry**.

### Configuration dans `.gitlab-ci.yml`

```yaml
docker-build:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  variables:
    DOCKER_TLS_CERTDIR: "/certs"
    IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
    IMAGE_LATEST: $CI_REGISTRY_IMAGE:latest
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $IMAGE_TAG -t $IMAGE_LATEST -f app/Dockerfile app/
    - docker push $IMAGE_TAG
    - docker push $IMAGE_LATEST
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
    - if: $CI_COMMIT_BRANCH == "develop"
```

### Explication Detaillee

| Element | Explication |
|---|---|
| `docker:24` | Image Docker officielle avec le CLI Docker |
| `docker:24-dind` | Docker-in-Docker : permet de construire des images dans le CI |
| `$CI_REGISTRY_IMAGE` | URL du Container Registry GitLab (automatique) |
| `$CI_COMMIT_SHORT_SHA` | Hash court du commit (tag unique) |
| Double tag | `:sha` pour la tracabilite + `:latest` pour la commodite |
| `rules` | Build uniquement sur `main` et `develop` |

### Alternative locale

```bash
cd app/
docker build -t finance-app:latest -f Dockerfile .
docker tag finance-app:latest finance-app:$(git rev-parse --short HEAD)

# Verifier l'image
docker images | grep finance-app

# Tester l'image
docker run -d --name finance-app-test -p 5000:5000 finance-app:latest
curl http://localhost:5000/health
docker rm -f finance-app-test
```

---

## 6. Stage 5 : Deploy (Ansible)

### Que fait ce stage ?

Deploy l'application sur l'environnement cible avec **Ansible**.

### Configuration dans `.gitlab-ci.yml`

```yaml
deploy-staging:
  stage: deploy
  image: cytopia/ansible:latest
  before_script:
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
    - echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
  script:
    - cd ansible
    - ansible-playbook -i inventory/staging.ini playbook.yml
      --extra-vars "app_image=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA app_version=$CI_COMMIT_SHORT_SHA"
  environment:
    name: staging
    url: http://staging.example.com:5002
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"
  when: manual

deploy-production:
  stage: deploy
  image: cytopia/ansible:latest
  before_script:
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
    - echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
  script:
    - cd ansible
    - ansible-playbook -i inventory/prod.ini playbook.yml
      --extra-vars "app_image=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA app_version=$CI_COMMIT_SHORT_SHA"
  environment:
    name: production
    url: http://prod.example.com:5000
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual
```

### Explication Detaillee

| Element | Explication |
|---|---|
| `cytopia/ansible:latest` | Image Docker avec Ansible pre-installe |
| `$SSH_PRIVATE_KEY` | Cle SSH pour se connecter aux serveurs (variable CI/CD) |
| `$SSH_KNOWN_HOSTS` | Fingerprints des serveurs (evite la question yes/no) |
| `--extra-vars` | Passe l'image Docker et la version au playbook Ansible |
| `environment` | Definit l'environnement dans GitLab (visible dans l'UI) |
| `when: manual` | Deploiement manuel (clic dans l'UI GitLab) |

### Alternative locale

```bash
cd ansible/

# Deploiement sur dev (localhost)
ansible-playbook -i inventory/dev.ini playbook.yml \
  --extra-vars "app_image=finance-app:latest app_version=local"

# Avec verbose pour debug
ansible-playbook -i inventory/dev.ini playbook.yml -vvv
```

---

## 7. Variables et Secrets

### Variables GitLab CI/CD a Configurer

Allez dans **Settings > CI/CD > Variables** dans votre projet GitLab :

| Variable | Valeur | Type | Masquee | Protegee |
|---|---|---|---|---|
| `SONAR_HOST_URL` | `http://sonarqube:9000` | Variable | Non | Non |
| `SONAR_TOKEN` | `sqa_xxxxx...` | Variable | **Oui** | **Oui** |
| `SSH_PRIVATE_KEY` | Contenu de `~/.ssh/id_rsa` | File | **Oui** | **Oui** |
| `SSH_KNOWN_HOSTS` | `ssh-keyscan serveur` | Variable | Non | Non |
| `DEPLOY_USER` | `deploy` | Variable | Non | Non |
| `DEPLOY_HOST_STAGING` | `staging.example.com` | Variable | Non | Non |
| `DEPLOY_HOST_PROD` | `prod.example.com` | Variable | Non | **Oui** |

### Options des Variables

- **Masquee (Masked)** : La valeur n'apparait pas dans les logs du pipeline
- **Protegee (Protected)** : La variable n'est disponible que sur les branches protegees
- **File** : La valeur est ecrite dans un fichier temporaire (utile pour les cles SSH)

### Pourquoi ces protections ?

Dans un contexte financier :
- Un token SonarQube expose → un attaquant pourrait masquer des vulnerabilites
- Une cle SSH exposee → acces direct aux serveurs de production
- Un secret en clair dans les logs → compromission immediate

---

## 8. Alternative Locale

### Script de Pipeline Local

Le script `scripts/pipeline-local.sh` reproduit les 5 stages du pipeline en local,
sans avoir besoin de GitLab CI.

```bash
# Executer le pipeline complet en local
chmod +x scripts/pipeline-local.sh
./scripts/pipeline-local.sh
```

Ce script execute sequentiellement :
1. **Tests** : `pytest` avec couverture
2. **Quality** : `sonar-scanner` (necessite SonarQube en local)
3. **Security** : `bandit` + `trivy`
4. **Build** : `docker build`
5. **Deploy** : `ansible-playbook` sur l'inventaire dev

### Tester un Stage Individuel

```bash
# Stage test uniquement
cd app && pytest tests/ -v --cov=.

# Stage security uniquement
./scripts/scan-security.sh

# Stage build uniquement
cd app && docker build -t finance-app:latest .

# Stage deploy uniquement
cd ansible && ansible-playbook -i inventory/dev.ini playbook.yml
```

---

## Fichiers a Examiner

- `.gitlab-ci.yml` — Pipeline complet (fichier principal)
- `scripts/pipeline-local.sh` — Alternative locale
- `scripts/scan-security.sh` — Scans securite en local
