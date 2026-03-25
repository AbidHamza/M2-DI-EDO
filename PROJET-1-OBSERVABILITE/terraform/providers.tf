# =============================================================================
# Terraform Provider Configuration
# =============================================================================
# The Docker provider allows Terraform to manage Docker resources
# (containers, images, networks, volumes) on the local machine.
#
# This demonstrates Infrastructure as Code (IaC) concepts:
# - Declarative infrastructure definition
# - Version-controlled infrastructure
# - Reproducible environments
# =============================================================================

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Configure the Docker provider.
# By default, it connects to the local Docker daemon via:
# - Linux/macOS: unix:///var/run/docker.sock
# - Windows:     npipe:////.//pipe//docker_engine
provider "docker" {
  # host = "unix:///var/run/docker.sock"  # Uncomment and adjust if needed
}
