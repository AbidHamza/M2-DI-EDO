# Exercice Phase 7 : Gestion sécurisée des secrets

## Exercice à réaliser

Configurez la gestion sécurisée des secrets dans le pipeline GitLab CI.

## Correction complète

### 1. Variables protégées dans GitLab

Dans GitLab : Settings > CI/CD > Variables

**Variables à créer :**
- `AWS_ACCESS_KEY_ID` (Protected, Masked)
- `AWS_SECRET_ACCESS_KEY` (Protected, Masked)
- `SONARQUBE_TOKEN` (Protected, Masked)
- `SSH_PRIVATE_KEY` (Protected, File)
- `DOCKER_REGISTRY_PASSWORD` (Protected, Masked)

### 2. Utilisation dans le pipeline

```yaml
# .gitlab-ci.yml
variables:
  DOCKER_REGISTRY: registry.gitlab.com
  DOCKER_REGISTRY_USER: $CI_REGISTRY_USER

# Job avec secrets
deploy:
  stage: deploy
  image: alpine:latest
  before_script:
    # Utilisation de variable protégée
    - echo $SSH_PRIVATE_KEY | base64 -d > ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
    - ssh-keyscan -H $DEPLOY_HOST >> ~/.ssh/known_hosts
  script:
    - ssh user@$DEPLOY_HOST "deploy.sh"
  only:
    - main
  # Utilise uniquement les variables protégées
```

### 3. Secrets pour Terraform

```hcl
# terraform/variables.tf
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}
```

```yaml
# Job Terraform dans GitLab CI
terraform_apply:
  stage: deploy
  image: hashicorp/terraform:latest
  script:
    - terraform init
    - terraform plan
      -var="aws_access_key=${AWS_ACCESS_KEY_ID}"
      -var="aws_secret_key=${AWS_SECRET_ACCESS_KEY}"
    - terraform apply -auto-approve
  only:
    - main
```

### 4. Secrets pour Ansible

```yaml
# ansible/vault.yml (chiffré avec ansible-vault)
# Créer avec: ansible-vault create vault.yml
---
vault_db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  ...

vault_api_key: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  ...
```

```yaml
# Utilisation dans playbook
- name: Deploy with secrets
  hosts: all
  vars_files:
    - vault.yml
  tasks:
    - name: Use secret
      debug:
        msg: "Password is {{ vault_db_password }}"
```

### 5. Scan de sécurité dans le pipeline

```yaml
# Job de scan de sécurité
security_scan:
  stage: quality
  image: aquasec/trivy:latest
  script:
    - trivy image --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_IMAGE}
  allow_failure: false
  only:
    - merge_requests
    - main
```

## Bonnes pratiques

1. **Jamais de secrets en clair** dans le code
2. **Variables protégées** pour les branches main/prod
3. **Masked variables** pour éviter l'affichage dans les logs
4. **File variables** pour les clés SSH
5. **Ansible Vault** pour les secrets complexes
6. **Scan des images** Docker pour les vulnérabilités

## Vérification

1. Vérifiez que les secrets ne sont pas dans les logs
2. Testez le déploiement avec les variables protégées
3. Vérifiez que les scans de sécurité fonctionnent

## Problèmes courants

- **Variable non trouvée** : Vérifiez qu'elle est définie et accessible
- **Secret exposé** : Vérifiez les logs et masquez la variable
- **Permission refusée** : Vérifiez les permissions de la variable

