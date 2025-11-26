# Correction Phase 3 : Premier script Terraform

## Correction complète

### Structure du projet Terraform

Créez cette structure :
```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

### Fichier main.tf

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
  description = "URL d'accès à Prometheus"
}
```

### Fichier variables.tf (optionnel pour cet exercice)

```hcl
variable "prometheus_port" {
  description = "Port externe pour Prometheus"
  type        = number
  default     = 9090
}
```

### Explications détaillées

**terraform block :**
- `required_version` : Version minimale de Terraform
- `required_providers` : Définit les providers nécessaires (Docker ici)

**provider "docker" :**
- Configure le provider Docker
- Utilise le socket Docker local

**resource "docker_network" :**
- Crée un réseau Docker isolé
- Permet la communication entre conteneurs

**resource "docker_volume" :**
- Crée un volume persistant
- Les données de Prometheus seront conservées même si le conteneur est supprimé

**resource "docker_container" :**
- Crée et démarre un conteneur
- `ports` : Mappe les ports (interne:externe)
- `volumes` : Monte des fichiers ou volumes
- `networks_advanced` : Connecte au réseau créé
- `restart` : Politique de redémarrage

**output :**
- Exporte une valeur après l'application
- Utile pour connaître l'URL d'accès

### Commandes d'exécution

**Windows (PowerShell) :**
```powershell
# Aller dans le dossier terraform
cd terraform

# Initialiser Terraform
terraform init

# Voir ce qui sera créé
terraform plan

# Appliquer (créer les ressources)
terraform apply

# Vérifier les outputs
terraform output

# Détruire (supprimer les ressources)
terraform destroy
```

**Linux/Mac :**
```bash
# Aller dans le dossier terraform
cd terraform

# Initialiser Terraform
terraform init

# Voir ce qui sera créé
terraform plan

# Appliquer (créer les ressources)
terraform apply

# Vérifier les outputs
terraform output

# Détruire (supprimer les ressources)
terraform destroy
```

### Vérification

1. **Vérifiez que le réseau est créé :**
   ```bash
   docker network ls | grep observability
   ```

2. **Vérifiez que le volume est créé :**
   ```bash
   docker volume ls | grep prometheus
   ```

3. **Vérifiez que le conteneur tourne :**
   ```bash
   docker ps | grep prometheus
   ```

4. **Accédez à Prometheus :**
   - Ouvrez http://localhost:9090
   - Vous devriez voir l'interface Prometheus

### Problèmes courants

**Erreur : Provider docker not found**
```bash
# Solution : Réinitialiser Terraform
terraform init -upgrade
```

**Erreur : Port already in use**
- Changez le port externe dans `ports { external = 9091 }`
- Ou arrêtez le service utilisant le port 9090

**Erreur : Cannot connect to Docker**
- Vérifiez que Docker est démarré
- Windows : Vérifiez que Docker Desktop est lancé
- Linux : Vérifiez les permissions `sudo usermod -aG docker $USER`

## Points clés à retenir

1. **Terraform est déclaratif** : Vous décrivez l'état désiré, Terraform fait le reste
2. **State management** : Terraform garde un état de ce qu'il a créé
3. **Idempotence** : Vous pouvez exécuter `terraform apply` plusieurs fois sans problème
4. **Destroy** : `terraform destroy` supprime tout ce qui a été créé

## Prochaine étape

Maintenant que vous maîtrisez Terraform, passez à la Phase 4 pour automatiser avec Ansible.

