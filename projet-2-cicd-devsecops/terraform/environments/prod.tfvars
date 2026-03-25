# =============================================================================
# Production Environment Variables
# =============================================================================
# Usage: terraform apply -var-file=environments/prod.tfvars
# =============================================================================

environment    = "prod"
app_name       = "finance-app"
app_image      = "finance-app:latest"
app_port       = 5000
app_replicas   = 2
log_level      = "WARNING"
debug_mode     = false
memory_limit   = 512
cpu_shares     = 512
restart_policy = "always"
