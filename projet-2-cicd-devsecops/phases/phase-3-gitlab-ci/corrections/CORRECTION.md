# Correction Phase 3 : Pipeline GitLab CI complet

## Pipeline complet

```yaml
stages:
  - test
  - quality
  - build
  - deploy

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  PYTHON_VERSION: "3.11"

test:
  stage: test
  image: python:${PYTHON_VERSION}
  script:
    - pip install -r requirements.txt
    - pytest tests/ --cov=. --cov-report=xml
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml

sonarqube:
  stage: quality
  image: sonarsource/sonar-scanner-cli:latest
  script:
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_NAME}
      -Dsonar.host.url=${SONARQUBE_URL}
      -Dsonar.login=${SONARQUBE_TOKEN}

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Deploying to production..."
```

### Configuration requise

1. Variables GitLab : SONARQUBE_URL, SONARQUBE_TOKEN
2. Docker Registry configuré
3. Tests dans le dossier tests/

