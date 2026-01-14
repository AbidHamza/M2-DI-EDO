# Correction Phase 9 : Multi-environnements

## Pipeline multi-environnements

```yaml
stages:
  - test
  - build
  - deploy-dev
  - deploy-prod

.deploy_template: &deploy_template
  script:
    - terraform init
    - terraform apply -auto-approve
    - ansible-playbook deploy.yml

deploy_dev:
  <<: *deploy_template
  stage: deploy-dev
  environment:
    name: development
    url: http://dev.example.com
  only:
    - develop
  when: on_success

deploy_prod:
  <<: *deploy_template
  stage: deploy-prod
  environment:
    name: production
    url: http://prod.example.com
  only:
    - main
  when: manual
```

### Configuration par environnement

**Terraform :**
```hcl
variable "environment" {
  type = string
}

locals {
  instance_types = {
    development = "t2.micro"
    production  = "t2.small"
  }
}
```

**Ansible :**
```yaml
# group_vars/development.yml
environment: development
debug: true

# group_vars/production.yml
environment: production
debug: false
```

