# Exercice Phase 3 : Pipeline GitLab CI complet

## Exercice à réaliser

Créez un pipeline GitLab CI complet avec les étapes : test, build, quality, deploy.

## Correction complète

```yaml
# .gitlab-ci.yml
stages:
  - test
  - quality
  - build
  - deploy

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  PYTHON_VERSION: "3.11"

# Stage: Test
test:
  stage: test
  image: python:${PYTHON_VERSION}
  before_script:
    - pip install -r requirements.txt
  script:
    - pytest tests/ --cov=. --cov-report=xml
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
    paths:
      - coverage.xml
    expire_in: 1 week

# Stage: Quality
sonarqube:
  stage: quality
  image: sonarsource/sonar-scanner-cli:latest
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script:
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_NAME}
      -Dsonar.sources=.
      -Dsonar.host.url=${SONARQUBE_URL}
      -Dsonar.login=${SONARQUBE_TOKEN}
  allow_failure: false

# Stage: Build
build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE
  only:
    - main
    - develop

# Stage: Deploy
deploy_dev:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o StrictHostKeyChecking=no user@dev-server "cd /app && docker-compose pull && docker-compose up -d"
  environment:
    name: development
    url: http://dev-server:8000
  only:
    - develop

deploy_prod:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Deploy to production"
  environment:
    name: production
    url: http://prod-server:8000
  when: manual
  only:
    - main
```

## Explications détaillées

**stages** : Définit l'ordre d'exécution

**variables** : Variables globales du pipeline

**test stage** : Exécute les tests avec couverture

**sonarqube stage** : Analyse le code avec SonarQube

**build stage** : Construit l'image Docker

**deploy stages** : Déploie selon l'environnement

**artifacts** : Fichiers produits par les jobs

**only/when** : Conditions d'exécution

## Vérification

Vérifiez que :
- Le pipeline s'exécute correctement
- Toutes les étapes passent
- L'application est déployée

