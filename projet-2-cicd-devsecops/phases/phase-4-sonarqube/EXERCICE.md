# Exercice Phase 4 : Intégration SonarQube dans le pipeline

## Exercice à réaliser

Intégrez SonarQube dans le pipeline GitLab CI pour analyser le code à chaque commit.

## Correction complète

```yaml
# .gitlab-ci.yml - Ajout du stage SonarQube
stages:
  - test
  - quality
  - build
  - deploy

# Variables SonarQube (définies dans GitLab CI/CD > Variables)
# SONARQUBE_URL=https://sonarqube.example.com
# SONARQUBE_TOKEN=your-token

sonarqube:
  stage: quality
  image: sonarsource/sonar-scanner-cli:latest
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: 0  # Nécessaire pour l'analyse
  cache:
    key: "${CI_JOB_NAME}-${CI_COMMIT_REF_SLUG}"
    paths:
      - .sonar/cache
  script:
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_NAME}
      -Dsonar.sources=.
      -Dsonar.host.url=${SONARQUBE_URL}
      -Dsonar.login=${SONARQUBE_TOKEN}
      -Dsonar.projectVersion=${CI_COMMIT_SHORT_SHA}
      -Dsonar.python.version=3.11
      -Dsonar.sourceEncoding=UTF-8
  allow_failure: false  # Bloque le pipeline si Quality Gate échoue
  only:
    - merge_requests
    - main
    - develop
```

## Configuration SonarQube

```properties
# sonar-project.properties
sonar.projectKey=example-api
sonar.projectName=Example API
sonar.projectVersion=1.0.0
sonar.sources=.
sonar.language=py
sonar.sourceEncoding=UTF-8
sonar.python.version=3.11

# Exclusions
sonar.exclusions=**/tests/**,**/venv/**,**/__pycache__/**

# Tests
sonar.python.xunit.reportPath=coverage.xml
sonar.coverage.exclusions=**/tests/**
```

## Quality Gate

Configurez dans SonarQube :
- Coverage > 80%
- Duplications < 3%
- Aucune vulnérabilité critique
- Aucun bug bloquant

## Intégration avec les rapports

```yaml
# Ajout dans le job sonarqube
artifacts:
  reports:
    sonarqube: sonar-report.json
  paths:
    - .sonar/
  expire_in: 1 week
```

## Vérification

1. Commitez du code
2. Vérifiez que le job SonarQube s'exécute
3. Consultez le rapport dans SonarQube
4. Vérifiez que le Quality Gate bloque si nécessaire

## Problèmes courants

- **Token invalide** : Régénérez le token dans SonarQube
- **Quality Gate toujours vert** : Vérifiez la configuration
- **Pas d'analyse** : Vérifiez sonar.sources

