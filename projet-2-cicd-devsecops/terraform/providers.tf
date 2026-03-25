# =============================================================================
# Terraform Providers Configuration
# =============================================================================
# Declares the Docker provider to manage containers, networks, and volumes.
# =============================================================================

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Docker provider — connects to the local Docker daemon
provider "docker" {
  # On Linux: unix:///var/run/docker.sock (default)
  # On Windows with Docker Desktop: npipe:////./pipe/docker_engine
  # On macOS: unix:///var/run/docker.sock (default)
}
