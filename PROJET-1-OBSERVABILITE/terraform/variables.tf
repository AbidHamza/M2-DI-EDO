# =============================================================================
# Terraform Variables
# =============================================================================
# Variables make the configuration reusable and parametrizable.
# Default values are set for the development environment.
# Override them with -var, .tfvars files, or environment variables.
# =============================================================================

# ---------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------

variable "network_name" {
  description = "Name of the Docker network for inter-container communication"
  type        = string
  default     = "observability-net"
}

# ---------------------------------------------------------------------------
# Application
# ---------------------------------------------------------------------------

variable "app_port" {
  description = "External port for the Flask application"
  type        = number
  default     = 5000
}

variable "app_image_name" {
  description = "Name for the built Flask application image"
  type        = string
  default     = "flask-observability-app"
}

# ---------------------------------------------------------------------------
# Prometheus
# ---------------------------------------------------------------------------

variable "prometheus_port" {
  description = "External port for Prometheus web UI"
  type        = number
  default     = 9090
}

variable "prometheus_image" {
  description = "Prometheus Docker image with tag"
  type        = string
  default     = "prom/prometheus:v2.51.0"
}

variable "prometheus_retention" {
  description = "Prometheus data retention period"
  type        = string
  default     = "15d"
}

# ---------------------------------------------------------------------------
# Grafana
# ---------------------------------------------------------------------------

variable "grafana_port" {
  description = "External port for Grafana web UI"
  type        = number
  default     = 3000
}

variable "grafana_image" {
  description = "Grafana Docker image with tag"
  type        = string
  default     = "grafana/grafana:10.4.0"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin"
  sensitive   = true
}

# ---------------------------------------------------------------------------
# Loki
# ---------------------------------------------------------------------------

variable "loki_port" {
  description = "External port for Loki"
  type        = number
  default     = 3100
}

variable "loki_image" {
  description = "Loki Docker image with tag"
  type        = string
  default     = "grafana/loki:2.9.4"
}

# ---------------------------------------------------------------------------
# Promtail
# ---------------------------------------------------------------------------

variable "promtail_image" {
  description = "Promtail Docker image with tag"
  type        = string
  default     = "grafana/promtail:2.9.4"
}

# ---------------------------------------------------------------------------
# Alertmanager
# ---------------------------------------------------------------------------

variable "alertmanager_port" {
  description = "External port for Alertmanager"
  type        = number
  default     = 9093
}

variable "alertmanager_image" {
  description = "Alertmanager Docker image with tag"
  type        = string
  default     = "prom/alertmanager:v0.27.0"
}

# ---------------------------------------------------------------------------
# Node Exporter
# ---------------------------------------------------------------------------

variable "node_exporter_port" {
  description = "External port for Node Exporter"
  type        = number
  default     = 9100
}

variable "node_exporter_image" {
  description = "Node Exporter Docker image with tag"
  type        = string
  default     = "prom/node-exporter:v1.7.0"
}

# ---------------------------------------------------------------------------
# Project paths (for volume mounts)
# ---------------------------------------------------------------------------

variable "project_root" {
  description = "Absolute path to the project root directory"
  type        = string
  default     = ".."
}
