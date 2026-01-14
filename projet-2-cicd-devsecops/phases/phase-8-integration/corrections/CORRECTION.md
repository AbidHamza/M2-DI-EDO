# Correction Phase 8 : Intégration complète

## Pipeline complet fonctionnel

```yaml
stages:
  - test
  - quality
  - build
  - deploy

test:
  stage: test
  image: python:3.11
  script:
    - pip install -r requirements.txt
    - pytest tests/

sonarqube:
  stage: quality
  image: sonarsource/sonar-scanner-cli:latest
  script:
    - sonar-scanner -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=$SONARQUBE_TOKEN
  allow_failure: false

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - ssh user@$DEPLOY_HOST "cd /app && docker-compose pull && docker-compose up -d"
```

### Checklist de validation

- [ ] Tests passent
- [ ] SonarQube analyse le code
- [ ] Quality Gate passe
- [ ] Image Docker construite
- [ ] Image poussée vers registry
- [ ] Application déployée
- [ ] Health check OK

