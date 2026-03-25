# Etape 5 : Terraform — Infrastructure as Code

> **Objectif** : Utiliser Terraform pour provisionner l'infrastructure Docker de
> l'application financiere, avec 3 environnements : dev, staging, prod.

---

## Table des Matieres

1. [Pourquoi Terraform ?](#1-pourquoi-terraform-)
2. [Installation](#2-installation)
3. [Architecture Terraform du Projet](#3-architecture-terraform-du-projet)
4. [Le Workflow plan → apply → destroy](#4-le-workflow-plan--apply--destroy)
5. [Multi-Environnement avec tfvars](#5-multi-environnement-avec-tfvars)
6. [Gestion du State](#6-gestion-du-state)
7. [Utilisation Pratique](#7-utilisation-pratique)
8. [Integration dans le Pipeline](#8-integration-dans-le-pipeline)

---

## 1. Pourquoi Terraform ?

### Docker Compose vs Terraform

Vous connaissez peut-etre `docker-compose.yml` pour deployer des conteneurs. Alors
pourquoi utiliser Terraform en plus ?

| Aspect | Docker Compose | Terraform |
|---|---|---|
| **Scope** | Une machine, Docker uniquement | Multi-provider (AWS, Azure, Docker...) |
| **State** | Pas de gestion d'etat | Fichier state (sait ce qui existe) |
| **Plan** | Pas de previsualisation | `terraform plan` avant d'appliquer |
| **Multi-env** | Fichiers `.env` limites | Fichiers `.tfvars` complets |
| **Idempotence** | Partielle | Complete |
| **Documentation** | Implicite | Le code `.tf` EST la documentation |

### Dans notre projet

Terraform est utilise pour :
1. **Provisionner les conteneurs Docker** de l'application
2. **Creer les reseaux Docker** isoles par environnement
3. **Gerer les volumes** pour la persistance des donnees
4. **Parametrer chaque environnement** differemment (ports, ressources, replicas)

---

## 2. Installation

### Linux / macOS

```bash
# Via le gestionnaire de paquets HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y

# Verifier
terraform --version
```

### Windows

```powershell
# Via Chocolatey
choco install terraform

# Ou telecharger depuis https://developer.hashicorp.com/terraform/downloads
```

---

## 3. Architecture Terraform du Projet

### Structure des Fichiers

```
terraform/
├── main.tf              # Ressources principales (conteneurs, reseaux, volumes)
├── variables.tf         # Declaration des variables
├── outputs.tf           # Valeurs de sortie (URL, IDs)
├── providers.tf         # Configuration du provider Docker
└── environments/        # Variables par environnement
    ├── dev.tfvars       # Parametres dev
    ├── staging.tfvars   # Parametres staging
    └── prod.tfvars      # Parametres prod
```

### Role de Chaque Fichier

| Fichier | Role | Contenu typique |
|---|---|---|
| `providers.tf` | Declare quels providers utiliser | `provider "docker" {}` |
| `variables.tf` | Declare les variables et leurs valeurs par defaut | `variable "app_port" {}` |
| `main.tf` | Definit les ressources a creer | Conteneurs, reseaux, volumes |
| `outputs.tf` | Expose des valeurs apres `apply` | URL de l'application |
| `*.tfvars` | Assigne des valeurs aux variables | `app_port = 5001` |

### Flux de Donnees

```
variables.tf          dev.tfvars
(declaration)    +    (valeurs)
      │                   │
      ▼                   ▼
┌─────────────────────────────────┐
│          main.tf                │
│                                 │
│  resource "docker_container" {  │
│    name  = var.app_name         │  ← utilise les variables
│    ports { internal = 5000      │
│            external = var.port }│
│  }                              │
└─────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────┐
│          outputs.tf             │
│                                 │
│  output "app_url" {             │
│    value = "http://localhost:${var.port}" │
│  }                              │
└─────────────────────────────────┘
```

---

## 4. Le Workflow plan → apply → destroy

### 4.1 terraform init

**Initialise** le repertoire de travail : telecharge les providers, cree le fichier state.

```bash
cd terraform/
terraform init
```

Sortie attendue :
```
Initializing the backend...
Initializing provider plugins...
- Installing kreuzwerker/docker v3.0.2...
Terraform has been successfully initialized!
```

### 4.2 terraform plan

**Previsualise** les changements sans rien appliquer. C'est comme un "dry-run".

```bash
terraform plan -var-file=environments/dev.tfvars
```

Sortie attendue :
```
Terraform will perform the following actions:

  # docker_network.finance_network will be created
  + resource "docker_network" "finance_network" {
      + name = "finance-dev-network"
    }

  # docker_container.finance_app will be created
  + resource "docker_container" "finance_app" {
      + name  = "finance-app-dev"
      + image = "finance-app:latest"
      + ports {
          + internal = 5000
          + external = 5001
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

**Pourquoi c'est important ?**
- Vous voyez EXACTEMENT ce qui va etre cree/modifie/detruit
- Pas de surprise → crucial dans un contexte financier
- Le correcteur peut voir que vous maitrisez votre infrastructure

### 4.3 terraform apply

**Applique** les changements et cree l'infrastructure.

```bash
terraform apply -var-file=environments/dev.tfvars
```

Terraform affiche le plan puis demande confirmation :
```
Do you want to perform these actions?
  Enter a value: yes

docker_network.finance_network: Creating...
docker_network.finance_network: Creation complete
docker_container.finance_app: Creating...
docker_container.finance_app: Creation complete

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:
  app_url = "http://localhost:5001"
  container_id = "abc123def456"
```

### 4.4 terraform destroy

**Supprime** toute l'infrastructure geree par Terraform.

```bash
terraform destroy -var-file=environments/dev.tfvars
```

```
Do you want to destroy all resources?
  Enter a value: yes

docker_container.finance_app: Destroying...
docker_network.finance_network: Destroying...

Destroy complete! Resources: 3 destroyed.
```

**Pourquoi c'est important ?**
- Nettoyage propre de l'environnement
- Pas de conteneurs orphelins
- Reproductibilite : on peut recreer exactement la meme chose

---

## 5. Multi-Environnement avec tfvars

### Le Principe

Les 3 environnements utilisent le **meme code Terraform** (`main.tf`) mais avec des
**parametres differents** (fichiers `.tfvars`).

### Comparaison des Environnements

| Parametre | dev.tfvars | staging.tfvars | prod.tfvars |
|---|---|---|---|
| `environment` | `dev` | `staging` | `prod` |
| `app_port` | `5001` | `5002` | `5000` |
| `app_replicas` | `1` | `1` | `2` |
| `log_level` | `DEBUG` | `INFO` | `WARNING` |
| `debug_mode` | `true` | `false` | `false` |

### Deployer un Environnement Specifique

```bash
# Deployer dev
terraform apply -var-file=environments/dev.tfvars

# Deployer staging
terraform apply -var-file=environments/staging.tfvars

# Deployer prod (avec auto-approve pour l'automatisation)
terraform apply -var-file=environments/prod.tfvars -auto-approve
```

### Avantage Cle

Le meme code produit des environnements differents. Si ca marche en staging,
ca marchera en prod (meme infrastructure, parametres differents).

---

## 6. Gestion du State

### 6.1 Qu'est-ce que le State ?

Le fichier `terraform.tfstate` contient l'**etat actuel** de l'infrastructure geree.
Terraform le compare avec le code `.tf` pour savoir ce qui doit changer.

```
Code .tf (etat desire) ←→ terraform.tfstate (etat reel) = Diff (plan)
```

### 6.2 State Local vs Remote

| Aspect | State Local | State Remote |
|---|---|---|
| Fichier | `terraform.tfstate` sur disque | S3, GCS, GitLab, etc. |
| Collaboration | Difficile (conflits) | Natif (locking) |
| Securite | En clair sur disque | Chiffre en transit |
| Backup | Manuel | Automatique |
| Adapte pour | Projets individuels, dev | Production, equipes |

### 6.3 Pour ce Projet

Nous utilisons un **state local** (suffisant pour un projet pedagogique).
Le fichier `terraform.tfstate` est dans le `.gitignore` car il peut contenir
des informations sensibles.

### 6.4 Bonnes Pratiques

```bash
# Ne JAMAIS commiter le state
echo "*.tfstate" >> .gitignore
echo "*.tfstate.backup" >> .gitignore

# Sauvegarder manuellement si necessaire
cp terraform.tfstate terraform.tfstate.backup
```

---

## 7. Utilisation Pratique

### 7.1 Deploiement Complet (Dev)

```bash
cd terraform/

# 1. Initialiser
terraform init

# 2. Planifier
terraform plan -var-file=environments/dev.tfvars

# 3. Appliquer
terraform apply -var-file=environments/dev.tfvars -auto-approve

# 4. Verifier
curl http://localhost:5001/health

# 5. Voir les outputs
terraform output
```

### 7.2 Modifier l'Infrastructure

Si vous changez une variable (par exemple le port) :

```bash
# Modifier dev.tfvars
# app_port = 5003  (au lieu de 5001)

# Planifier → voir le diff
terraform plan -var-file=environments/dev.tfvars
# Plan: 0 to add, 1 to change, 0 to destroy.

# Appliquer
terraform apply -var-file=environments/dev.tfvars
```

### 7.3 Nettoyer

```bash
# Detruire l'environnement dev
terraform destroy -var-file=environments/dev.tfvars -auto-approve
```

---

## 8. Integration dans le Pipeline

### Dans GitLab CI

Terraform peut etre utilise dans le stage `deploy` du pipeline :

```yaml
deploy-terraform:
  stage: deploy
  image:
    name: hashicorp/terraform:1.6
    entrypoint: [""]
  script:
    - cd terraform
    - terraform init
    - terraform plan -var-file=environments/${CI_ENVIRONMENT_NAME}.tfvars
    - terraform apply -var-file=environments/${CI_ENVIRONMENT_NAME}.tfvars -auto-approve
  environment:
    name: $CI_ENVIRONMENT_NAME
```

### Avec Ansible (notre approche)

Dans notre pipeline, Terraform provisionne l'infrastructure, et Ansible deploie
l'application dessus. Les deux sont complementaires :

```
Terraform                          Ansible
(cree l'infrastructure)    →       (deploie l'application)

Conteneurs Docker                  Pull image
Reseaux                           Configure
Volumes                           Health check
```

---

## Fichiers a Examiner

- `terraform/main.tf` — Ressources principales
- `terraform/variables.tf` — Variables declarees
- `terraform/outputs.tf` — Sorties
- `terraform/providers.tf` — Provider Docker
- `terraform/environments/dev.tfvars` — Parametres dev
- `terraform/environments/staging.tfvars` — Parametres staging
- `terraform/environments/prod.tfvars` — Parametres prod
