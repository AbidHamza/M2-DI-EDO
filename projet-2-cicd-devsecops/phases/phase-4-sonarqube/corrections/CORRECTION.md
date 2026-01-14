# Correction Phase 4 : Intégration SonarQube

## Configuration complète

### .gitlab-ci.yml - Job SonarQube

```yaml
sonarqube:
  stage: quality
  image: sonarsource/sonar-scanner-cli:latest
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: 0
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
  allow_failure: false
```

### sonar-project.properties

```properties
sonar.projectKey=example-api
sonar.projectName=Example API
sonar.projectVersion=1.0.0
sonar.sources=.
sonar.language=py
sonar.sourceEncoding=UTF-8
sonar.python.version=3.11
sonar.exclusions=**/tests/**,**/venv/**,**/__pycache__/**
```

### Configuration SonarCloud (gratuit)

1. Créez un compte sur sonarcloud.io
2. Créez un projet
3. Générez un token
4. Ajoutez les variables dans GitLab :
   - SONARQUBE_URL : https://sonarcloud.io
   - SONARQUBE_TOKEN : votre token

### Vérification

1. Le pipeline doit exécuter SonarQube
2. Consultez le rapport sur SonarCloud
3. Vérifiez le Quality Gate

