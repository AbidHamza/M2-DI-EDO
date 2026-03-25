# =============================================================================
# Terraform Main Configuration
# =============================================================================
# This file provisions the complete observability stack using Docker.
# It creates: network, volumes, images, and containers.
#
# This is the Terraform equivalent of docker-compose.yml, demonstrating
# how Infrastructure as Code works with a declarative approach.
# =============================================================================

# ---------------------------------------------------------------------------
# Docker Network
# ---------------------------------------------------------------------------
# All containers share this network for inter-service communication.
# Container names serve as DNS hostnames within the network.

resource "docker_network" "observability" {
  name   = var.network_name
  driver = "bridge"
}

# ---------------------------------------------------------------------------
# Docker Volumes (persistent storage)
# ---------------------------------------------------------------------------

resource "docker_volume" "prometheus_data" {
  name = "observability-prometheus-data"
}

resource "docker_volume" "grafana_data" {
  name = "observability-grafana-data"
}

resource "docker_volume" "loki_data" {
  name = "observability-loki-data"
}

resource "docker_volume" "alertmanager_data" {
  name = "observability-alertmanager-data"
}

# ---------------------------------------------------------------------------
# Docker Images
# ---------------------------------------------------------------------------
# Pull the required images from Docker Hub.

resource "docker_image" "prometheus" {
  name         = var.prometheus_image
  keep_locally = true
}

resource "docker_image" "grafana" {
  name         = var.grafana_image
  keep_locally = true
}

resource "docker_image" "loki" {
  name         = var.loki_image
  keep_locally = true
}

resource "docker_image" "promtail" {
  name         = var.promtail_image
  keep_locally = true
}

resource "docker_image" "alertmanager" {
  name         = var.alertmanager_image
  keep_locally = true
}

resource "docker_image" "node_exporter" {
  name         = var.node_exporter_image
  keep_locally = true
}

# ---------------------------------------------------------------------------
# Container: Prometheus
# ---------------------------------------------------------------------------
# Metrics collection and storage server.
# Scrapes /metrics endpoints from configured targets every 15 seconds.

resource "docker_container" "prometheus" {
  name  = "observability-prometheus"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = var.prometheus_port
  }

  # Mount configuration files (read-only)
  volumes {
    host_path      = abspath("${var.project_root}/prometheus/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }

  volumes {
    host_path      = abspath("${var.project_root}/prometheus/alert-rules.yml")
    container_path = "/etc/prometheus/alert-rules.yml"
    read_only      = true
  }

  # Persistent data volume
  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus",
    "--storage.tsdb.retention.time=${var.prometheus_retention}",
    "--web.enable-lifecycle",
  ]

  networks_advanced {
    name = docker_network.observability.name
  }

  restart = "unless-stopped"
}

# ---------------------------------------------------------------------------
# Container: Grafana
# ---------------------------------------------------------------------------
# Visualization platform. Auto-provisions datasources and dashboards.

resource "docker_container" "grafana" {
  name  = "observability-grafana"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = var.grafana_port
  }

  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
    "GF_AUTH_ANONYMOUS_ENABLED=false",
  ]

  # Auto-provisioning: datasources
  volumes {
    host_path      = abspath("${var.project_root}/grafana/provisioning")
    container_path = "/etc/grafana/provisioning"
    read_only      = true
  }

  # Auto-provisioning: dashboard JSON files
  volumes {
    host_path      = abspath("${var.project_root}/grafana/dashboards")
    container_path = "/var/lib/grafana/dashboards"
    read_only      = true
  }

  # Persistent data volume
  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  networks_advanced {
    name = docker_network.observability.name
  }

  restart = "unless-stopped"

  depends_on = [
    docker_container.prometheus,
    docker_container.loki,
  ]
}

# ---------------------------------------------------------------------------
# Container: Loki
# ---------------------------------------------------------------------------
# Log aggregation system. Receives logs from Promtail.

resource "docker_container" "loki" {
  name  = "observability-loki"
  image = docker_image.loki.image_id

  ports {
    internal = 3100
    external = var.loki_port
  }

  volumes {
    host_path      = abspath("${var.project_root}/loki/loki-config.yml")
    container_path = "/etc/loki/local-config.yaml"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.loki_data.name
    container_path = "/loki"
  }

  command = ["-config.file=/etc/loki/local-config.yaml"]

  networks_advanced {
    name = docker_network.observability.name
  }

  restart = "unless-stopped"
}

# ---------------------------------------------------------------------------
# Container: Promtail
# ---------------------------------------------------------------------------
# Log collector agent. Discovers Docker containers and ships logs to Loki.

resource "docker_container" "promtail" {
  name  = "observability-promtail"
  image = docker_image.promtail.image_id

  volumes {
    host_path      = abspath("${var.project_root}/docker/promtail-config.yml")
    container_path = "/etc/promtail/config.yml"
    read_only      = true
  }

  # Docker socket for container discovery
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }

  # Docker container logs
  volumes {
    host_path      = "/var/lib/docker/containers"
    container_path = "/var/lib/docker/containers"
    read_only      = true
  }

  command = ["-config.file=/etc/promtail/config.yml"]

  networks_advanced {
    name = docker_network.observability.name
  }

  restart = "unless-stopped"

  depends_on = [
    docker_container.loki,
  ]
}

# ---------------------------------------------------------------------------
# Container: Alertmanager
# ---------------------------------------------------------------------------
# Receives alerts from Prometheus and routes notifications.

resource "docker_container" "alertmanager" {
  name  = "observability-alertmanager"
  image = docker_image.alertmanager.image_id

  ports {
    internal = 9093
    external = var.alertmanager_port
  }

  volumes {
    host_path      = abspath("${var.project_root}/alertmanager/alertmanager.yml")
    container_path = "/etc/alertmanager/alertmanager.yml"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.alertmanager_data.name
    container_path = "/alertmanager"
  }

  command = [
    "--config.file=/etc/alertmanager/alertmanager.yml",
    "--storage.path=/alertmanager",
  ]

  networks_advanced {
    name = docker_network.observability.name
  }

  restart = "unless-stopped"
}

# ---------------------------------------------------------------------------
# Container: Node Exporter
# ---------------------------------------------------------------------------
# Exposes host-level system metrics (CPU, memory, disk, network).

resource "docker_container" "node_exporter" {
  name  = "observability-node-exporter"
  image = docker_image.node_exporter.image_id

  ports {
    internal = 9100
    external = var.node_exporter_port
  }

  # Mount host filesystems for accurate metrics collection
  volumes {
    host_path      = "/proc"
    container_path = "/host/proc"
    read_only      = true
  }

  volumes {
    host_path      = "/sys"
    container_path = "/host/sys"
    read_only      = true
  }

  command = [
    "--path.procfs=/host/proc",
    "--path.sysfs=/host/sys",
    "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)",
  ]

  networks_advanced {
    name = docker_network.observability.name
  }

  restart = "unless-stopped"
}
