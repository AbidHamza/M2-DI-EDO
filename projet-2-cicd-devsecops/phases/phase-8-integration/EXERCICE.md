# Exercice Phase 8 : Intégration complète du pipeline

## Exercice à réaliser

Intégrez tous les composants et testez le pipeline CI/CD complet de bout en bout.

## Correction complète - Pipeline GitLab CI complet

```yaml
# .gitlab-ci.yml - Pipeline complet intégré
stages:
  - test
  - quality
  - build
  - provision
  - deploy

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  DOCKER_REGISTRY: $CI_REGISTRY
  PYTHON_VERSION: "3.11"
  TERRAFORM_VERSION: "1.6.0"

# ============================================
# STAGE 1: TEST
# ============================================
test:
  stage: test
  image: python:${PYTHON_VERSION}
  before_script:
    - pip install -r requirements.txt
    - pip install pytest pytest-cov
  script:
    - echo "Running unit tests..."
    - pytest tests/ --cov=. --cov-report=xml --cov-report=html
    - echo "Tests completed"
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
    paths:
      - coverage.xml
      - htmlcov/
    expire_in: 1 week
  only:
    - merge_requests
    - main
    - develop

# ============================================
# STAGE 2: QUALITY
# ============================================
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
    - echo "Running SonarQube analysis..."
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_NAME}
      -Dsonar.sources=.
      -Dsonar.host.url=${SONARQUBE_URL}
      -Dsonar.login=${SONARQUBE_TOKEN}
      -Dsonar.projectVersion=${CI_COMMIT_SHORT_SHA}
      -Dsonar.python.version=${PYTHON_VERSION}
      -Dsonar.sourceEncoding=UTF-8
      -Dsonar.coverage.exclusions=**/tests/**
    - echo "SonarQube analysis completed"
  allow_failure: false
  only:
    - merge_requests
    - main
    - develop

# ============================================
# STAGE 3: BUILD
# ============================================
build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - echo "Logging in to Docker registry..."
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - echo "Building Docker image..."
    - docker build -t $DOCKER_IMAGE .
    - echo "Pushing Docker image..."
    - docker push $DOCKER_IMAGE
    - echo "Build completed: $DOCKER_IMAGE"
  only:
    - main
    - develop

# ============================================
# STAGE 4: PROVISION (Terraform)
# ============================================
terraform_plan:
  stage: provision
  image: hashicorp/terraform:${TERRAFORM_VERSION}
  variables:
    TF_ROOT: ${CI_PROJECT_DIR}/terraform
  before_script:
    - cd $TF_ROOT
    - terraform --version
    - terraform init -backend-config="key=${CI_PROJECT_NAME}/terraform.tfstate"
  script:
    - echo "Planning infrastructure changes..."
    - terraform plan
      -var="environment=${CI_COMMIT_REF_SLUG}"
      -var="app_image=${DOCKER_IMAGE}"
      -out=tfplan
  artifacts:
    paths:
      - $TF_ROOT/tfplan
    expire_in: 1 hour
  only:
    - main
    - develop

terraform_apply:
  stage: provision
  image: hashicorp/terraform:${TERRAFORM_VERSION}
  variables:
    TF_ROOT: ${CI_PROJECT_DIR}/terraform
  dependencies:
    - terraform_plan
  before_script:
    - cd $TF_ROOT
    - terraform init
  script:
    - echo "Applying infrastructure changes..."
    - terraform apply -auto-approve tfplan
    - echo "Infrastructure provisioned"
  environment:
    name: ${CI_COMMIT_REF_SLUG}
    action: start
  only:
    - main
    - develop
  when: manual  # Approbation manuelle pour production

# ============================================
# STAGE 5: DEPLOY (Ansible)
# ============================================
deploy:
  stage: deploy
  image: cytopia/ansible:latest
  variables:
    ANSIBLE_HOST_KEY_CHECKING: "False"
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan -H $DEPLOY_HOST >> ~/.ssh/known_hosts
    - cd ${CI_PROJECT_DIR}/ansible
  script:
    - echo "Deploying application with Ansible..."
    - ansible-playbook -i inventory deploy.yml
      -e "docker_image=${DOCKER_IMAGE}"
      -e "environment=${CI_COMMIT_REF_SLUG}"
      -e "deploy_host=${DEPLOY_HOST}"
    - echo "Deployment completed"
  environment:
    name: ${CI_COMMIT_REF_SLUG}
    url: http://${DEPLOY_HOST}:8000
  only:
    - main
    - develop
  when: on_success

# ============================================
# VERIFICATION
# ============================================
verify_deployment:
  stage: deploy
  image: curlimages/curl:latest
  script:
    - echo "Verifying deployment..."
    - sleep 10  # Attendre que l'application démarre
    - |
      for i in {1..10}; do
        if curl -f http://${DEPLOY_HOST}:8000/health; then
          echo "Application is healthy!"
          exit 0
        fi
        echo "Waiting for application... ($i/10)"
        sleep 5
      done
    - echo "Application verification failed"
    - exit 1
  only:
    - main
    - develop
  when: on_success
```

## Tests end-to-end

### Test 1 : Pipeline complet

1. **Créez une branche feature**
   ```bash
   git checkout -b feature/test-pipeline
   ```

2. **Faites un commit**
   ```bash
   git add .
   git commit -m "test: test pipeline"
   git push origin feature/test-pipeline
   ```

3. **Créez une Merge Request**
   - Dans GitLab, créez une MR
   - Le pipeline doit s'exécuter automatiquement

4. **Vérifiez chaque stage**
   - Test : Doit passer
   - Quality : SonarQube doit analyser
   - Build : Image Docker doit être créée
   - Provision : Terraform doit planifier
   - Deploy : Ansible doit déployer

### Test 2 : Quality Gate

1. **Commitez du code avec des problèmes**
   ```python
   # Code intentionnellement mauvais pour tester
   def bad_function():
       x = 1
       y = 2
       z = x + y  # Variable non utilisée
       return None  # Retourne toujours None
   ```

2. **Vérifiez que SonarQube détecte les problèmes**
3. **Vérifiez que le Quality Gate bloque si nécessaire**

### Test 3 : Déploiement automatique

1. **Mergez dans develop**
   - Le pipeline doit déployer automatiquement en dev
   - Vérifiez que l'application est accessible

2. **Mergez dans main**
   - Le pipeline doit demander une approbation manuelle
   - Après approbation, déploie en production

## Script de validation

```bash
#!/bin/bash
# validate_pipeline.sh

echo "=== Validating CI/CD Pipeline ==="

# Test 1: Application builds
echo "Test 1: Building application..."
docker build -t test-app . || exit 1

# Test 2: Tests pass
echo "Test 2: Running tests..."
pytest tests/ || exit 1

# Test 3: SonarQube configuration
echo "Test 3: Checking SonarQube config..."
test -f .sonar-project.properties || exit 1

# Test 4: Terraform syntax
echo "Test 4: Validating Terraform..."
cd terraform
terraform init -backend=false
terraform validate || exit 1
cd ..

# Test 5: Ansible syntax
echo "Test 5: Validating Ansible..."
ansible-playbook --syntax-check ansible/deploy.yml || exit 1

echo "=== All validations passed! ==="
```

## Checklist de validation

- [ ] Pipeline s'exécute sur chaque commit
- [ ] Tests unitaires passent
- [ ] SonarQube analyse le code
- [ ] Quality Gate fonctionne
- [ ] Image Docker est construite
- [ ] Image est poussée vers le registry
- [ ] Terraform provisionne l'infrastructure
- [ ] Ansible déploie l'application
- [ ] Application est accessible après déploiement
- [ ] Health check répond
- [ ] Secrets ne sont pas exposés dans les logs

## Captures à faire

1. **Pipeline en cours** : Tous les jobs en vert
2. **Rapport SonarQube** : Quality Gate passé
3. **Build réussi** : Image Docker créée
4. **Terraform apply** : Infrastructure provisionnée
5. **Ansible deploy** : Application déployée
6. **Application accessible** : Health check OK

## Problèmes courants

- **Pipeline bloqué** : Vérifiez les quality gates
- **Build échoue** : Vérifiez Dockerfile et dépendances
- **Terraform échoue** : Vérifiez les credentials et permissions
- **Ansible échoue** : Vérifiez SSH et inventory

## Prochaine phase

Passez à la **Phase 9 : Multi-environnements**.

