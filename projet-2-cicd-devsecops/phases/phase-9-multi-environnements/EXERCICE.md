# Exercice Phase 9 : Pipeline multi-environnements

## Exercice à réaliser

Configurez le pipeline pour gérer les déploiements vers plusieurs environnements (dev, staging, production).

## Correction complète - Pipeline multi-environnements

```yaml
# .gitlab-ci.yml - Multi-environnements
stages:
  - test
  - quality
  - build
  - deploy-dev
  - deploy-staging
  - deploy-prod

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  PYTHON_VERSION: "3.11"

# ============================================
# STAGES COMMUNS
# ============================================
test:
  stage: test
  image: python:${PYTHON_VERSION}
  script:
    - pytest tests/
  only:
    - merge_requests
    - main
    - develop

sonarqube:
  stage: quality
  image: sonarsource/sonar-scanner-cli:latest
  script:
    - sonar-scanner
  only:
    - merge_requests
    - main
    - develop

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE
  only:
    - main
    - develop

# ============================================
# ENVIRONNEMENT: DEVELOPMENT
# ============================================
.deploy_template: &deploy_template
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh && chmod 700 ~/.ssh
    - ssh-keyscan -H ${DEPLOY_HOST} >> ~/.ssh/known_hosts
  script:
    - cd terraform && terraform init && terraform apply -auto-approve
    - cd ../ansible && ansible-playbook -i inventory deploy.yml
  after_script:
    - curl -f http://${DEPLOY_HOST}:8000/health || exit 1

deploy_dev:
  <<: *deploy_template
  stage: deploy-dev
  variables:
    DEPLOY_HOST: $DEV_SERVER_HOST
    ENVIRONMENT: development
  environment:
    name: development
    url: http://$DEV_SERVER_HOST:8000
  only:
    - develop
  when: on_success

# ============================================
# ENVIRONNEMENT: STAGING
# ============================================
deploy_staging:
  <<: *deploy_template
  stage: deploy-staging
  variables:
    DEPLOY_HOST: $STAGING_SERVER_HOST
    ENVIRONMENT: staging
  environment:
    name: staging
    url: http://$STAGING_SERVER_HOST:8000
  only:
    - main
  when: on_success

# ============================================
# ENVIRONNEMENT: PRODUCTION
# ============================================
deploy_prod:
  <<: *deploy_template
  stage: deploy-prod
  variables:
    DEPLOY_HOST: $PROD_SERVER_HOST
    ENVIRONMENT: production
  environment:
    name: production
    url: http://$PROD_SERVER_HOST:8000
  only:
    - main
  when: manual  # Approbation manuelle requise
  dependencies:
    - build
```

## Configuration des environnements

### Variables d'environnement GitLab

Créez dans GitLab : Settings > CI/CD > Variables

**Pour Development :**
- `DEV_SERVER_HOST` (non protégée, pour branche develop)
- `DEV_SSH_PRIVATE_KEY` (protégée, pour branche develop)

**Pour Staging :**
- `STAGING_SERVER_HOST` (protégée, pour branche main)
- `STAGING_SSH_PRIVATE_KEY` (protégée, pour branche main)

**Pour Production :**
- `PROD_SERVER_HOST` (protégée, pour branche main)
- `PROD_SSH_PRIVATE_KEY` (protégée, pour branche main)

## Terraform multi-environnements

```hcl
# terraform/variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# terraform/main.tf
locals {
  instance_types = {
    development = "t2.micro"
    staging     = "t2.small"
    production  = "t2.medium"
  }
  
  instance_type = local.instance_types[var.environment]
}

resource "aws_instance" "app" {
  instance_type = local.instance_type
  # ... autres configurations
  tags = {
    Environment = var.environment
  }
}
```

## Ansible multi-environnements

```yaml
# ansible/inventory
[development]
dev-server ansible_host=${DEV_SERVER_HOST}

[staging]
staging-server ansible_host=${STAGING_SERVER_HOST}

[production]
prod-server ansible_host=${PROD_SERVER_HOST}

# ansible/group_vars/development.yml
environment: development
app_port: 8000
debug: true

# ansible/group_vars/production.yml
environment: production
app_port: 8000
debug: false
```

## Promotion entre environnements

### Workflow de promotion

```
feature/* → develop → main
    ↓          ↓        ↓
   Dev      Staging   Prod
  (Auto)    (Auto)   (Manual)
```

### Configuration de promotion

```yaml
# Promotion automatique dev → staging
deploy_staging:
  # ... configuration
  only:
    - main
  when: on_success  # Automatique après build

# Promotion manuelle staging → prod
deploy_prod:
  # ... configuration
  only:
    - main
  when: manual  # Requiert approbation
```

## Approbations manuelles

### Configuration dans GitLab

1. Allez dans Settings > CI/CD > Protected environments
2. Protégez l'environnement "production"
3. Ajoutez des utilisateurs autorisés à approuver

### Dans le pipeline

```yaml
deploy_prod:
  # ... configuration
  environment:
    name: production
    deployment_tier: production
  when: manual
  only:
    - main
```

## Tests de validation

### Test 1 : Déploiement automatique dev

```bash
# Créez une branche develop
git checkout -b develop
git push origin develop

# Vérifiez que le pipeline déploie automatiquement en dev
# Application accessible sur http://dev-server:8000
```

### Test 2 : Déploiement automatique staging

```bash
# Mergez develop dans main
git checkout main
git merge develop
git push origin main

# Vérifiez que le pipeline déploie automatiquement en staging
# Application accessible sur http://staging-server:8000
```

### Test 3 : Déploiement manuel production

```bash
# Dans GitLab, allez dans CI/CD > Pipelines
# Cliquez sur "play" pour deploy_prod
# Approbation requise

# Après approbation, vérifiez le déploiement
# Application accessible sur http://prod-server:8000
```

## Checklist de validation

- [ ] Pipeline déploie automatiquement en dev (branche develop)
- [ ] Pipeline déploie automatiquement en staging (branche main)
- [ ] Pipeline demande approbation pour production
- [ ] Variables d'environnement correctes pour chaque env
- [ ] Infrastructure différente selon l'environnement
- [ ] Application accessible dans chaque environnement
- [ ] Health checks fonctionnent dans chaque env

## Problèmes courants

- **Mauvais environnement** : Vérifiez les variables et conditions
- **Secrets non accessibles** : Vérifiez les permissions des variables
- **Déploiement échoue** : Vérifiez les credentials et hosts

## Prochaine phase

Passez à la **Phase 10 : Analyse et amélioration**.

