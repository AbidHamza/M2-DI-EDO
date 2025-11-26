# Correction Phase 7 : Sécurisation

## Gestion des secrets dans GitLab

### Variables protégées

Dans GitLab : Settings → CI/CD → Variables

**Variables à créer :**
- `RAILWAY_TOKEN` : Protected, Masked
- `SONARQUBE_TOKEN` : Protected, Masked
- `SSH_PRIVATE_KEY` : Protected, File
- `DOCKER_REGISTRY_PASSWORD` : Protected, Masked

### Utilisation dans le pipeline

```yaml
deploy:
  variables:
    RAILWAY_TOKEN: $RAILWAY_TOKEN  # Variable protégée
  script:
    - railway login --token $RAILWAY_TOKEN
    - railway up
```

### Ansible Vault

```bash
# Créer un fichier vault
ansible-vault create vault.yml

# Contenu du vault.yml
---
vault_db_password: secret123
vault_api_key: key456
```

**Utilisation :**
```yaml
- name: Use secret
  vars_files:
    - vault.yml
  tasks:
    - debug:
        msg: "Password is {{ vault_db_password }}"
```

### Scan de sécurité

```yaml
security_scan:
  stage: quality
  image: aquasec/trivy:latest
  script:
    - trivy image --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_IMAGE}
```

