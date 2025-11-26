# Correction Phase 5 : Terraform pour infrastructure

## Configuration pour services gratuits

### Railway (recommandé - gratuit)

```hcl
terraform {
  required_providers {
    railway = {
      source  = "railwayapp/railway"
      version = "~> 1.0"
    }
  }
}

provider "railway" {
  token = var.railway_token
}

resource "railway_project" "app" {
  name = "example-app"
}

resource "railway_service" "api" {
  project_id = railway_project.app.id
  name       = "api"
}
```

### Render (gratuit)

```hcl
terraform {
  required_providers {
    render = {
      source  = "render-io/render"
      version = "~> 1.0"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

resource "render_service" "api" {
  name             = "example-api"
  type             = "web_service"
  runtime          = "docker"
  docker_image_url = var.docker_image
}
```

### Local avec Docker (100% gratuit)

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app" {
  name = "app-network"
}

resource "docker_container" "api" {
  name  = "api"
  image = var.docker_image
  
  ports {
    internal = 8000
    external = 8000
  }
  
  networks_advanced {
    name = docker_network.app.name
  }
}
```

### Variables

```hcl
variable "railway_token" {
  description = "Railway API token"
  type        = string
  sensitive   = true
}

variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "myapp:latest"
}
```

