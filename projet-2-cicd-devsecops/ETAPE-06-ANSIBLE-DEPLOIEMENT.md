# Etape 6 : Ansible — Deploiement Automatise

> **Objectif** : Utiliser Ansible pour deployer automatiquement l'application financiere
> sur les differents environnements, avec gestion des secrets via Ansible Vault.

---

## Table des Matieres

1. [Pourquoi Ansible ?](#1-pourquoi-ansible-)
2. [Installation](#2-installation)
3. [Architecture Ansible du Projet](#3-architecture-ansible-du-projet)
4. [Inventaires par Environnement](#4-inventaires-par-environnement)
5. [Le Playbook de Deploiement](#5-le-playbook-de-deploiement)
6. [Les Roles](#6-les-roles)
7. [Ansible Vault pour les Secrets](#7-ansible-vault-pour-les-secrets)
8. [Integration avec Terraform](#8-integration-avec-terraform)
9. [Execution en Local](#9-execution-en-local)

---

## 1. Pourquoi Ansible ?

### Le Probleme

Deployer une application manuellement implique :
1. Se connecter au serveur (SSH)
2. Telecharger la nouvelle image Docker
3. Arreter l'ancien conteneur
4. Demarrer le nouveau
5. Verifier que tout fonctionne
6. Repeter pour chaque serveur, chaque environnement...

→ Fastidieux, source d'erreurs, non reproductible.

### La Solution Ansible

Ansible automatise tout ca dans un **playbook** (script YAML) :
- **Declaratif** : vous decrivez l'etat desire, pas les commandes
- **Idempotent** : executer 2 fois = meme resultat
- **Sans agent** : se connecte par SSH, rien a installer sur les cibles
- **Reproductible** : meme playbook = meme deploiement

### Ansible dans le Pipeline CI/CD

```
GitLab CI Pipeline :
  ... → Build (Docker) → Deploy (Ansible) → ...
                                │
                     ┌──────────┴──────────┐
                     │  ansible-playbook   │
                     │  -i inventory/prod  │
                     │  playbook.yml       │
                     │                     │
                     │  1. Pull image      │
                     │  2. Deploy app      │
                     │  3. Health check    │
                     └─────────────────────┘
```

---

## 2. Installation

```bash
# Via pip (recommande)
pip3 install ansible

# Verifier
ansible --version
# ansible [core 2.15.x]

# Installer les collections necessaires
ansible-galaxy collection install community.docker
```

---

## 3. Architecture Ansible du Projet

### Structure des Fichiers

```
ansible/
├── ansible.cfg                  # Configuration Ansible
├── playbook.yml                 # Playbook principal
├── inventory/                   # Inventaires par environnement
│   ├── dev.ini                  # Serveurs dev (localhost)
│   ├── staging.ini              # Serveurs staging
│   └── prod.ini                 # Serveurs production
└── roles/                       # Roles reutilisables
    └── deploy/                  # Role de deploiement
        ├── tasks/
        │   └── main.yml         # Taches de deploiement
        └── templates/
            └── docker-compose.yml.j2  # Template Jinja2
```

### Role de Chaque Fichier

| Fichier | Role |
|---|---|
| `ansible.cfg` | Configuration globale (timeouts, parametres SSH, privileges) |
| `playbook.yml` | Orchestration : quels roles appliquer sur quels hotes |
| `inventory/*.ini` | Liste des serveurs cibles par environnement |
| `roles/deploy/tasks/main.yml` | Taches detaillees du deploiement |
| `roles/deploy/templates/*.j2` | Templates avec variables Jinja2 |

---

## 4. Inventaires par Environnement

### Qu'est-ce qu'un Inventaire ?

Un inventaire est un fichier qui liste les **serveurs cibles** et leurs **variables**.

### Format INI

```ini
[app_servers]
server1 ansible_host=192.168.1.10 ansible_user=deploy

[app_servers:vars]
ansible_python_interpreter=/usr/bin/python3
app_port=5000
```

### Nos 3 Inventaires

| Environnement | Fichier | Cible | Port |
|---|---|---|---|
| **Dev** | `inventory/dev.ini` | `localhost` (connexion locale) | 5001 |
| **Staging** | `inventory/staging.ini` | Serveur staging (SSH) | 5002 |
| **Prod** | `inventory/prod.ini` | Serveur production (SSH) | 5000 |

### Pourquoi localhost pour Dev ?

En developpement, on deploie sur sa propre machine. Ansible utilise la connexion
`local` au lieu de SSH, ce qui simplifie le setup.

```ini
# inventory/dev.ini
[app_servers]
localhost ansible_connection=local
```

---

## 5. Le Playbook de Deploiement

### Structure du Playbook

```yaml
---
# playbook.yml
- name: Deploy Finance Application
  hosts: app_servers          # Groupe cible (defini dans l'inventaire)
  become: yes                 # Executer avec sudo
  vars:
    app_image: "finance-app:latest"  # Valeur par defaut
    app_version: "latest"
  roles:
    - deploy                  # Applique le role "deploy"
```

### Explication

| Element | Role |
|---|---|
| `hosts: app_servers` | Cible le groupe defini dans l'inventaire |
| `become: yes` | Eleve les privileges (sudo) pour Docker |
| `vars` | Variables par defaut (peuvent etre surchargees) |
| `roles: [deploy]` | Execute le role `deploy` (dans `roles/deploy/`) |

### Surcharge des Variables

Les variables peuvent etre surchargees a plusieurs niveaux (par ordre de priorite) :
1. `--extra-vars` en ligne de commande (priorite maximale)
2. Variables du playbook
3. Variables de l'inventaire
4. Variables par defaut du role

```bash
# Surcharger l'image et la version
ansible-playbook -i inventory/prod.ini playbook.yml \
  --extra-vars "app_image=registry.example.com/finance-app:v1.2.3 app_version=v1.2.3"
```

---

## 6. Les Roles

### 6.1 Qu'est-ce qu'un Role ?

Un **role** est un module reutilisable qui regroupe :
- Des **taches** (tasks) : les actions a executer
- Des **templates** : fichiers avec variables Jinja2
- Des **handlers** : actions declenchees par des changements
- Des **variables par defaut** : valeurs de fallback

### 6.2 Notre Role "deploy"

Le role `deploy` execute les taches suivantes :

```
1. Verifier que Docker est installe
       │
       ▼
2. Creer le repertoire de l'application
       │
       ▼
3. Generer le docker-compose.yml (template Jinja2)
       │
       ▼
4. Pull l'image Docker
       │
       ▼
5. Deployer avec docker compose
       │
       ▼
6. Attendre que l'application demarre
       │
       ▼
7. Health check : verifier /health
       │
       ▼
8. Afficher l'URL de l'application
```

### 6.3 Templates Jinja2

Le fichier `docker-compose.yml.j2` est un template qui utilise les variables Ansible :

```yaml
# Ce n'est PAS un fichier statique, les {{ }} sont remplaces par Ansible
version: "3.8"
services:
  finance-app:
    image: {{ app_image }}
    ports:
      - "{{ app_port }}:5000"
    environment:
      - APP_ENV={{ environment }}
      - LOG_LEVEL={{ log_level }}
```

Quand Ansible deploie sur **dev** :
```yaml
services:
  finance-app:
    image: finance-app:latest
    ports:
      - "5001:5000"
    environment:
      - APP_ENV=dev
      - LOG_LEVEL=DEBUG
```

Quand Ansible deploie sur **prod** :
```yaml
services:
  finance-app:
    image: finance-app:v1.2.3
    ports:
      - "5000:5000"
    environment:
      - APP_ENV=prod
      - LOG_LEVEL=WARNING
```

### 6.4 Handlers

Un **handler** est une tache qui ne s'execute que si elle est **notifiee** par une autre
tache. Typiquement : redemarrer un service apres un changement de configuration.

```yaml
# Dans tasks/main.yml
- name: Deploy docker-compose
  template:
    src: docker-compose.yml.j2
    dest: /opt/finance-app/docker-compose.yml
  notify: restart finance-app    # ← Notifie le handler

# Le handler (appele si le template a change)
handlers:
  - name: restart finance-app
    command: docker compose -f /opt/finance-app/docker-compose.yml restart
```

---

## 7. Ansible Vault pour les Secrets

### 7.1 Le Probleme

Les playbooks Ansible peuvent contenir des secrets :
- Mots de passe de bases de donnees
- Tokens d'API
- Cles de chiffrement

Ces secrets ne doivent **JAMAIS** etre dans le code en clair.

### 7.2 La Solution : Ansible Vault

Ansible Vault **chiffre** les fichiers ou variables sensibles avec AES-256.

### 7.3 Utilisation

```bash
# Chiffrer un fichier
ansible-vault encrypt secrets.yml
# Demande un mot de passe de vault

# Editer un fichier chiffre
ansible-vault edit secrets.yml

# Dechiffrer
ansible-vault decrypt secrets.yml

# Voir le contenu sans dechiffrer le fichier
ansible-vault view secrets.yml
```

### 7.4 Utiliser le Vault dans le Pipeline

```bash
# Option 1 : Fichier de mot de passe
echo "mon-mot-de-passe-vault" > .vault_password
ansible-playbook playbook.yml --vault-password-file .vault_password

# Option 2 : Variable d'environnement (GitLab CI)
export ANSIBLE_VAULT_PASSWORD=mon-mot-de-passe-vault
ansible-playbook playbook.yml --vault-password-file <(echo $ANSIBLE_VAULT_PASSWORD)
```

### 7.5 Bonnes Pratiques

| Pratique | Explication |
|---|---|
| **Ne jamais commiter `.vault_password`** | Ajoutez-le au `.gitignore` |
| **Un vault par environnement** | `vault_dev.yml`, `vault_prod.yml` |
| **Prefix `vault_`** | Nommez les variables chiffrees `vault_db_password` |
| **Rotation reguliere** | Changez le mot de passe du vault periodiquement |

---

## 8. Integration avec Terraform

### Terraform + Ansible : Complementarite

| Aspect | Terraform | Ansible |
|---|---|---|
| **Cree** l'infrastructure | Conteneurs, reseaux, volumes | - |
| **Configure** les serveurs | - | Installe packages, configure services |
| **Deploie** l'application | - | Pull image, docker compose up |
| **Verifie** le deploiement | - | Health checks |

### Workflow Complet

```
1. Terraform cree l'infrastructure
   terraform apply -var-file=environments/prod.tfvars
       │
       ▼
2. Ansible deploie l'application
   ansible-playbook -i inventory/prod.ini playbook.yml
       │
       ▼
3. Application disponible
   curl http://prod-server:5000/health
```

### Inventaire Dynamique (Avance)

Terraform peut generer un inventaire Ansible automatiquement :

```bash
# Generer l'inventaire depuis Terraform
terraform output -json | python3 -c "
import json, sys
data = json.load(sys.stdin)
print('[app_servers]')
print(f\"{data['app_host']['value']} ansible_port=22\")
" > inventory/dynamic.ini
```

---

## 9. Execution en Local

### 9.1 Deploiement Dev (localhost)

```bash
cd ansible/

# Deployer sur localhost
ansible-playbook -i inventory/dev.ini playbook.yml

# Avec verbose pour debug
ansible-playbook -i inventory/dev.ini playbook.yml -vvv

# Avec des variables supplementaires
ansible-playbook -i inventory/dev.ini playbook.yml \
  --extra-vars "app_image=finance-app:latest app_version=dev"
```

### 9.2 Verifier la Syntaxe

```bash
# Verifier la syntaxe du playbook (sans executer)
ansible-playbook -i inventory/dev.ini playbook.yml --syntax-check

# Mode dry-run (check mode)
ansible-playbook -i inventory/dev.ini playbook.yml --check

# Lister les taches
ansible-playbook -i inventory/dev.ini playbook.yml --list-tasks
```

### 9.3 Tester un Seul Hote

```bash
# Ping test
ansible -i inventory/dev.ini app_servers -m ping

# Executer une commande ad-hoc
ansible -i inventory/dev.ini app_servers -m shell -a "docker ps"
```

---

## Fichiers a Examiner

- `ansible/ansible.cfg` — Configuration Ansible
- `ansible/playbook.yml` — Playbook principal
- `ansible/inventory/dev.ini` — Inventaire dev
- `ansible/inventory/staging.ini` — Inventaire staging
- `ansible/inventory/prod.ini` — Inventaire prod
- `ansible/roles/deploy/tasks/main.yml` — Taches de deploiement
- `ansible/roles/deploy/templates/docker-compose.yml.j2` — Template
