# Etape 3 : Infrastructure avec Terraform

## Objectif

Dans cette etape, nous utilisons **Terraform** pour provisionner notre infrastructure d'observabilite. Plutot que de creer manuellement des conteneurs Docker avec `docker run`, nous declarons l'infrastructure souhaitee dans des fichiers `.tf` et laissons Terraform la creer.

Cela demontre le concept d'**Infrastructure as Code (IaC)** : l'infrastructure est versionnable, reproductible et auditable.

---

## Pourquoi Terraform pour ce Projet ?

Dans un contexte professionnel, Terraform provisionnerait des VMs sur AWS/Azure/GCP. Pour ce projet pedagogique, nous utilisons le **provider Docker** de Terraform pour :

1. **Demontrer les concepts IaC** sans necesiter un compte cloud
2. **Creer des conteneurs Docker** de maniere declarative
3. **Gerer le cycle de vie** de l'infrastructure (create, update, destroy)
4. **Versionner l'infrastructure** dans Git

> **Note** : Le `docker-compose.yml` (Etape 5) est une alternative plus simple pour lancer la stack. Terraform est utilise ici pour satisfaire les exigences du sujet et demontrer la maitrise de l'outil.

---

## Structure des Fichiers Terraform

```
terraform/
|-- providers.tf    # Configuration du provider Docker
|-- variables.tf    # Variables reutilisables
|-- main.tf         # Ressources principales (conteneurs, reseaux, volumes)
|-- outputs.tf      # URLs et informations de sortie
```

### Separation des Fichiers

La convention Terraform est de separer le code en fichiers thematiques :
- **providers.tf** : quels providers utiliser et comment se connecter
- **variables.tf** : parametres configurables (ports, versions, noms)
- **main.tf** : les ressources a creer (le coeur de la configuration)
- **outputs.tf** : les informations a afficher apres `terraform apply`

---

## 1. Provider Docker (providers.tf)

Le provider Docker permet a Terraform de communiquer avec le daemon Docker local.

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.7.0"
}

provider "docker" {
  # Sur Linux/macOS : unix:///var/run/docker.sock (par defaut)
  # Sur Windows avec Docker Desktop : npipe:////.//pipe//docker_engine
}
```

**Explication :**
- `required_providers` : declare le provider Docker et sa version
- `required_version` : version minimum de Terraform requise
- Le provider se connecte au daemon Docker local via le socket Unix

---

## 2. Variables (variables.tf)

Les variables rendent la configuration **flexible** et **reutilisable**.

```hcl
variable "app_port" {
  description = "Port expose pour l'application Flask"
  type        = number
  default     = 5000
}

variable "prometheus_port" {
  description = "Port expose pour Prometheus"
  type        = number
  default     = 9090
}
```

**Pourquoi des variables ?**
- Changer un port sans modifier le code principal
- Reutiliser la configuration dans differents environnements (dev, staging, prod)
- Documenter les parametres configurables

---

## 3. Ressources Principales (main.tf)

Le fichier `main.tf` declare toutes les ressources Docker :

### Reseau Docker
```hcl
resource "docker_network" "observability" {
  name = var.network_name
}
```

### Conteneur Prometheus
```hcl
resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = var.prometheus_port
  }

  volumes {
    host_path      = abspath("../prometheus/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
  }

  networks_advanced {
    name = docker_network.observability.name
  }
}
```

**Explication de chaque bloc :**
- `resource "docker_container"` : type de ressource Terraform
- `name` : nom du conteneur Docker
- `image` : reference a l'image Docker (declaree separement)
- `ports` : mapping de ports (interne → externe)
- `volumes` : montage de fichiers de configuration
- `networks_advanced` : connexion au reseau partage

---

## 4. Sorties (outputs.tf)

Les outputs affichent les informations utiles apres le deploiement :

```hcl
output "grafana_url" {
  value       = "http://localhost:${var.grafana_port}"
  description = "URL d'acces a Grafana"
}
```

---

## 5. Cycle de Vie Terraform

### Initialisation
```bash
cd terraform/
terraform init
```
Telecharge le provider Docker et initialise le repertoire de travail.

### Planification
```bash
terraform plan
```
Affiche les changements prevus **sans les appliquer**. Toujours verifier le plan avant d'appliquer !

### Application
```bash
terraform apply
```
Cree les ressources. Terraform demande confirmation (sauf avec `-auto-approve`).

### Verification
```bash
terraform show          # Affiche l'etat actuel
docker ps               # Verifie les conteneurs
curl http://localhost:5000/health  # Teste l'application
```

### Destruction
```bash
terraform destroy
```
Supprime toutes les ressources creees par Terraform.

---

## 6. Le Fichier d'Etat (terraform.tfstate)

Terraform maintient un **fichier d'etat** (`terraform.tfstate`) qui enregistre les ressources creees et leur configuration actuelle.

**Points importants :**
- Ne **jamais modifier** ce fichier manuellement
- Ne **jamais le committer** s'il contient des secrets (ajoutez-le au `.gitignore`)
- En production, utilisez un **backend distant** (S3, Azure Blob, etc.)
- Le fichier d'etat permet a Terraform de savoir quoi creer, modifier ou detruire

---

## 7. Points Cles pour le Rapport

- Expliquez la **philosophie declarative** de Terraform ("je declare ce que je veux, pas comment le faire")
- Montrez le **plan Terraform** et expliquez les symboles (`+` = creer, `~` = modifier, `-` = detruire)
- Comparez l'approche Terraform avec `docker-compose` : avantages et inconvenients
- Capturez les **sorties de `terraform apply`** avec les URLs
- Discutez de la **gestion de l'etat** et des backends distants
- Mentionnez les **limitations** du provider Docker (pas de health checks avances, pas de depends_on Docker Compose style)
