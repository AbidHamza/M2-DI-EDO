# Exercice Phase 7 – Secrets & scans dans GitLab CI

## Objectif

Mettre en place :
1. Des variables protégées/masquées pour vos secrets.
2. Un job `security_scan` qui analyse l’image Docker avec Trivy (ou équivalent).

## Étapes guidées

1. **Créer les variables GitLab**
   - `SSH_PRIVATE_KEY` (File, Protected, Masked)
   - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (Protected, Masked)
   - `SONARQUBE_TOKEN`, `DOCKER_REGISTRY_PASSWORD`

2. **Utilisation dans le pipeline**
   ```yaml
   deploy:
     stage: deploy
     image: alpine:latest
     before_script:
       - apk add --no-cache openssh-client
       - mkdir -p ~/.ssh && chmod 700 ~/.ssh
       - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
       - chmod 600 ~/.ssh/id_rsa
       - ssh-keyscan -H "$DEPLOY_HOST" >> ~/.ssh/known_hosts
     script:
       - ssh "$DEPLOY_USER@$DEPLOY_HOST" "cd /app && ./deploy.sh"
     only:
       - main
   ```

3. **Terraform sensible**
   ```hcl
   variable "aws_access_key" {
     type      = string
     sensitive = true
   }
   ```
   ```yaml
   terraform_plan:
     stage: deploy
     image: hashicorp/terraform:latest
     script:
       - terraform init
       - terraform plan \
           -var="aws_access_key=${AWS_ACCESS_KEY_ID}" \
           -var="aws_secret_key=${AWS_SECRET_ACCESS_KEY}"
   ```

4. **Ansible Vault**
   ```bash
   ansible-vault create ansible/group_vars/all/vault.yml
   ```
   Utilisez `vars_files` dans vos playbooks.

5. **Job Trivy**
   ```yaml
   security_scan:
     stage: quality
     image: aquasec/trivy:latest
     script:
       - trivy image --exit-code 1 --severity HIGH,CRITICAL "$DOCKER_IMAGE"
     allow_failure: false
     rules:
       - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
       - if: '$CI_COMMIT_BRANCH == "main"'
   ```

## Vérifications attendues

- Aucun secret n’apparaît dans les logs.
- Les jobs échouent si une vulnérabilité critique est détectée.
- Les playbooks Ansible peuvent consommer les secrets via Vault ou variables protégées.

## Solution expliquée

Disponible (chiffrée) dans `corrections/` avec :
- liste exhaustive des secrets ;
- exemples de rules GitLab Security scanning ;
- bonnes pratiques de rotation.

## Pour aller plus loin

- Ajouter des rapports GitLab Security (`dependency_scanning`, `container_scanning`).
- Mettre en place des approved deploys pour la prod.
- Documenter un processus de rotation des secrets tous les X jours.*** End Patch

