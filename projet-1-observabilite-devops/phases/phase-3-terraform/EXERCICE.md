# Exercice Phase 3 : Premier script Terraform

## Exercice à réaliser

Créez un script Terraform simple pour provisionner une infrastructure locale (Docker) ou cloud.

## Correction complète

```hcl
# main.tf
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

# Resource: Network
resource "docker_network" "observability" {
  name = "observability-network"
}

# Resource: Volume pour Prometheus
resource "docker_volume" "prometheus_data" {
  name = "prometheus-data"
}

# Resource: Container Prometheus
resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = "prom/prometheus:latest"
  
  ports {
    internal = 9090
    external = 9090
  }
  
  volumes {
    host_path      = "${path.cwd}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
  
  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }
  
  networks_advanced {
    name = docker_network.observability.name
  }
  
  restart = "unless-stopped"
}

# Output
output "prometheus_url" {
  value = "http://localhost:9090"
}
```

## Explications détaillées

**terraform block** : Configuration Terraform et providers requis

**provider "docker"** : Provider pour gérer Docker

**resource "docker_network"** : Crée un réseau Docker

**resource "docker_volume"** : Crée un volume persistant

**resource "docker_container"** : Crée un conteneur

**output** : Valeur exportée après l'application

## Commandes

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Vérification

Vérifiez que :
- Le réseau est créé
- Le volume est créé
- Le conteneur Prometheus est démarré
- Prometheus est accessible sur http://localhost:9090

