# Exercice Phase 5 – Scénario Terraform minimal

## Objectif

Réaliser un projet Terraform simple (AWS free tier, Scaleway, Docker provider ou VMware local) afin de :
- définir un provider ;
- créer au moins un composant réseau + une machine/app ;
- produire un output réutilisable (IP, URL).

## Étapes guidées

1. **Init du projet**
   ```bash
   mkdir terraform-lab && cd terraform-lab
   cat > main.tf <<'EOF'
   terraform {
     required_version = ">= 1.4"
     required_providers {
       docker = {
         source  = "kreuzwerker/docker"
         version = "~> 3.0"
       }
     }
   }

   provider "docker" {}
   EOF
   ```

2. **Déclarer une ressource**
   Exemple Docker :
   ```hcl
   resource "docker_network" "cicd" {
     name = "cicd-network"
   }

   resource "docker_container" "app" {
     name  = "app-server"
     image = "nginx:stable"
     ports {
       internal = 80
       external = 8080
     }
     networks_advanced {
       name = docker_network.cicd.name
     }
   }

   output "app_url" {
     value = "http://localhost:8080"
   }
   ```

3. **Variables (optionnel)**
   - Ajoutez un fichier `variables.tf` pour paramétrer les ports, noms de réseau, etc.

4. **Commandes**
   ```bash
   terraform fmt
   terraform init
   terraform plan
   terraform apply
   ```

5. **Nettoyage**
   - `terraform destroy` pour supprimer les ressources.

## Vérifications attendues

- Les ressources sont visibles (ex : `docker ps`, `docker network ls` ou AWS Console).
- Les outputs affichent les informations utiles.
- `terraform plan` n’indique plus de changements après l’application.

## Solution expliquée

Dans `corrections/`, vous trouverez un exemple complet (provider AWS + réseau + instance + outputs) commenté. Comparez avec votre travail pour voir comment gérer les providers cloud, le state et les user_data.

## Pour aller plus loin

- Ajouter un module réutilisable (`modules/app_server`).
- Stocker le state dans un backend distant (S3, Terraform Cloud).
- Relier Terraform à GitLab CI (job `terraform plan/apply`).*** End Patch

