# =============================================================================
# Development Environment Variables
# =============================================================================
# Usage: terraform apply -var-file=environments/dev.tfvars
# =============================================================================

environment    = "dev"
app_name       = "finance-app"
app_image      = "finance-app:latest"
app_port       = 5001
app_replicas   = 1
log_level      = "DEBUG"
debug_mode     = true
memory_limit   = 128
cpu_shares     = 128
restart_policy = "unless-stopped"
