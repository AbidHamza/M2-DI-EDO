# Exercice Phase 3 – Premier module Terraform

## Objectif

Écrire un projet Terraform minimal utilisant le provider Docker pour créer :
- un réseau dédié à l’observabilité ;
- un volume persistant ;
- un conteneur Prometheus prêt à l’emploi.

Cet exercice vous offre un terrain sûr pour tester les commandes Terraform avant d’industrialiser l’architecture complète.

## Pré-requis

- Terraform ≥ 1.0 installé (`terraform version`)
- Docker en fonctionnement (`docker ps`)
- Fichier `prometheus.yml` exemple (fourni dans `application-example/` ou créé rapidement)

## Étapes guidées

1. **Initialiser le projet**
   - Créez un dossier `exercice-terraform`.
   - Ajoutez un fichier `main.tf` et copiez la structure suivante :
     ```hcl
     terraform {
       required_version = ">= 1.0"
       required_providers {
         docker = {
           source  = "kreuzwerker/docker"
           version = "~> 3.0"
         }
       }
     }

     provider "docker" {}
     ```

2. **Déclarer les ressources**
   - Réseau Docker `observability-network`
   - Volume `prometheus-data`
   - Conteneur `prom/prometheus:latest` connecté au réseau, avec :
     - mappage de port `9090:9090`
     - montage du fichier `prometheus.yml`
     - montage du volume de données

3. **Ajouter un output**
   - Exportez l’URL d’accès à Prometheus :
     ```hcl
     output "prometheus_url" {
       value = "http://localhost:9090"
     }
     ```

4. **Tester les commandes**
   ```bash
   terraform fmt
   terraform init
   terraform plan
   terraform apply
   ```
   - Répondez “yes” lorsqu’on vous demande de confirmer l’application.

5. **Nettoyer**
   - Pour vous entraîner, exécutez `terraform destroy` puis relancez `apply`.

## Vérifications attendues

- Le réseau et le volume apparaissent dans `docker network ls` / `docker volume ls`.
- Le conteneur `prometheus` tourne (`docker ps`).
- L’interface est accessible sur http://localhost:9090.
- `terraform state list` affiche vos ressources.

## Solution expliquée

Le dossier `corrections/` contient une solution détaillée (fichier chiffré ou réservé aux encadrants). Déchiffrez-la uniquement après avoir tenté l’exercice : elle explique chaque bloc et propose des variantes (provider local vs cloud).

## Pour aller plus loin

- Paramétrez les ports et chemins via des variables (`variables.tf`).
- Ajoutez un deuxième conteneur (Grafana ou application exemple) pour tester les dépendances réseau.
- Expérimentez avec un backend de state distant (ex : local file backend vs S3/MinIO).

