# =============================================================================
# Terraform Outputs
# =============================================================================
# Outputs display useful information after `terraform apply` completes.
# They can also be consumed by other Terraform modules or scripts.
# =============================================================================

output "app_url" {
  value       = "http://localhost:${var.app_port}"
  description = "URL to access the Flask application"
}

output "prometheus_url" {
  value       = "http://localhost:${var.prometheus_port}"
  description = "URL to access the Prometheus web UI"
}

output "grafana_url" {
  value       = "http://localhost:${var.grafana_port}"
  description = "URL to access Grafana (login: admin/admin)"
}

output "alertmanager_url" {
  value       = "http://localhost:${var.alertmanager_port}"
  description = "URL to access the Alertmanager web UI"
}

output "loki_url" {
  value       = "http://localhost:${var.loki_port}"
  description = "URL for Loki API (used by Grafana datasource)"
}

output "node_exporter_url" {
  value       = "http://localhost:${var.node_exporter_port}/metrics"
  description = "URL to access Node Exporter metrics"
}

output "service_urls" {
  value = <<-EOT

    ============================================================
    Observability Stack deployed successfully!
    ============================================================

    Application:    http://localhost:${var.app_port}
    Prometheus:     http://localhost:${var.prometheus_port}
    Grafana:        http://localhost:${var.grafana_port}  (admin/admin)
    Alertmanager:   http://localhost:${var.alertmanager_port}
    Loki:           http://localhost:${var.loki_port}
    Node Exporter:  http://localhost:${var.node_exporter_port}/metrics

    ============================================================
  EOT
  description = "Summary of all service URLs"
}
