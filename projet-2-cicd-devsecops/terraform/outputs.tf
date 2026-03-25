# =============================================================================
# Terraform Outputs
# =============================================================================
# Values displayed after 'terraform apply' and accessible via 'terraform output'.
# =============================================================================

output "app_url" {
  description = "URL to access the Finance App"
  value       = "http://localhost:${var.app_port}"
}

output "health_check_url" {
  description = "URL for the health check endpoint"
  value       = "http://localhost:${var.app_port}/health"
}

output "metrics_url" {
  description = "URL for the Prometheus metrics endpoint"
  value       = "http://localhost:${var.app_port}/metrics"
}

output "environment" {
  description = "Current deployment environment"
  value       = var.environment
}

output "container_names" {
  description = "Names of the deployed containers"
  value       = [for c in docker_container.finance_app : c.name]
}

output "container_ids" {
  description = "IDs of the deployed containers"
  value       = [for c in docker_container.finance_app : c.id]
}

output "network_name" {
  description = "Docker network name"
  value       = docker_network.finance_network.name
}

output "volume_name" {
  description = "Docker volume name"
  value       = docker_volume.finance_data.name
}

output "app_ports" {
  description = "External ports for each container replica"
  value       = [for i in range(var.app_replicas) : var.app_replicas > 1 ? var.app_port + i : var.app_port]
}
