# Etape 05 : CI/CD avec GitLab

## Objectif

Creer un pipeline GitLab CI/CD qui automatise les tests, la construction et le deploiement de votre application.

## Duree estimee

1h-1h30

## Instructions pas a pas

### Etape 5.1 : Creer le fichier .gitlab-ci.yml

A la racine de votre projet, creez un fichier nomme `.gitlab-ci.yml` avec le contenu suivant :

```yaml
image: docker:latest

services:
  - docker:dind

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

stages:
  - validate
  - build
  - test
  - deploy

validate-python:
  stage: validate
  image: python:3.10
  script:
    - echo "Validation du code Python"
    - pip install flake8
    - flake8 --max-line-length=120 *.py || true
  only:
    - merge_requests
    - main

build-docker-image:
  stage: build
  script:
    - echo "Construction de l'image Docker"
    - docker build -t mon-app:$CI_COMMIT_SHORT_SHA .
  only:
    - main
    - develop

test-application:
  stage: test
  image: python:3.10
  script:
    - echo "Execution des tests"
    - pip install -r requirements.txt
    - python -m pytest tests/ || true
  only:
    - merge_requests
    - main

deploy-railway:
  stage: deploy
  image: node:16
  script:
    - echo "Deploiement sur Railway"
    - npm install -g @railway/cli
    - railway login --token $RAILWAY_TOKEN
    - railway up
  only:
    - main
  when: manual
```

### Etape 5.2 : Pousser le fichier sur GitLab

```bash
git add .gitlab-ci.yml
git commit -m "Ajout du pipeline GitLab CI/CD"
git push origin main
```

### Etape 5.3 : Verifier le pipeline

1. Allez sur votre projet GitLab
2. Cliquez sur "CI/CD" dans le menu de gauche
3. Cliquez sur "Pipelines"
4. Vous devriez voir votre pipeline en cours d'execution

### Etape 5.4 : Configurer les variables (si necessaire)

Si vous utilisez Railway pour le deploiement :

1. Allez sur Settings → CI/CD → Variables
2. Ajoutez la variable `RAILWAY_TOKEN` avec votre token Railway
3. Cochez "Mask variable" pour cacher la valeur

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le fichier .gitlab-ci.yml existe a la racine
- [ ] Le pipeline s'execute automatiquement a chaque push
- [ ] Les stages s'executent dans l'ordre (validate, build, test)
- [ ] Les logs sont accessibles et lisibles

## Problemes courants

### Le pipeline ne se declenche pas

**Solution** : Verifiez que le fichier s'appelle exactement `.gitlab-ci.yml` et qu'il est a la racine

### Erreur "docker: command not found"

**Solution** : Verifiez que `services: - docker:dind` est present dans le fichier

### Variables non trouvees

**Solution** : Verifiez que les variables sont bien definies dans Settings → CI/CD → Variables

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 06 : Containerisation](ETAPE-06-CONTAINERISATION.md)
