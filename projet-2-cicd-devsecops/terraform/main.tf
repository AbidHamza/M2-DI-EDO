# =============================================================================
# Terraform Main Configuration — Finance App Infrastructure
# =============================================================================
# Creates Docker resources: network, volume, and application container(s).
# Parameterized by environment via .tfvars files.
# =============================================================================

# ---------------------------------------------------------------------------
# Docker Network — isolated network per environment
# ---------------------------------------------------------------------------
resource "docker_network" "finance_network" {
  name   = "${var.app_name}-${var.environment}-network"
  driver = "bridge"

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "project"
    value = var.app_name
  }
}

# ---------------------------------------------------------------------------
# Docker Volume — persistent data storage
# ---------------------------------------------------------------------------
resource "docker_volume" "finance_data" {
  name = "${var.app_name}-${var.environment}-data"

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "project"
    value = var.app_name
  }
}

# ---------------------------------------------------------------------------
# Docker Image — pull the application image
# ---------------------------------------------------------------------------
resource "docker_image" "finance_app" {
  name         = var.app_image
  keep_locally = true
}

# ---------------------------------------------------------------------------
# Docker Container — application instance(s)
# ---------------------------------------------------------------------------
resource "docker_container" "finance_app" {
  count = var.app_replicas

  name  = var.app_replicas > 1 ? "${var.app_name}-${var.environment}-${count.index + 1}" : "${var.app_name}-${var.environment}"
  image = docker_image.finance_app.image_id

  # Port mapping
  ports {
    internal = var.app_internal_port
    external = var.app_replicas > 1 ? var.app_port + count.index : var.app_port
  }

  # Environment variables
  env = [
    "APP_ENV=${var.environment}",
    "LOG_LEVEL=${var.log_level}",
    "APP_VERSION=1.0.0",
    "APP_NAME=${var.app_name}",
    "DEBUG=${var.debug_mode}",
  ]

  # Network configuration
  networks_advanced {
    name = docker_network.finance_network.id
  }

  # Volume mount
  volumes {
    volume_name    = docker_volume.finance_data.name
    container_path = "/app/data"
    read_only      = false
  }

  # Resource limits
  memory = var.memory_limit

  # Restart policy
  restart = var.restart_policy

  # Container labels for identification and management
  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "project"
    value = var.app_name
  }

  labels {
    label = "managed-by"
    value = "terraform"
  }

  # Health check
  healthcheck {
    test         = ["CMD-SHELL", "python -c \"import urllib.request; urllib.request.urlopen('http://localhost:${var.app_internal_port}/health')\" || exit 1"]
    interval     = "30s"
    timeout      = "5s"
    start_period = "10s"
    retries      = 3
  }

  # Ensure the container is always running
  must_run = true

  # Wait for the image to be pulled
  depends_on = [
    docker_image.finance_app,
    docker_network.finance_network,
  ]
}
