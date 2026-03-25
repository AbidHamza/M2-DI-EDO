# =============================================================================
# Staging Environment Variables
# =============================================================================
# Usage: terraform apply -var-file=environments/staging.tfvars
# =============================================================================

environment    = "staging"
app_name       = "finance-app"
app_image      = "finance-app:latest"
app_port       = 5002
app_replicas   = 1
log_level      = "INFO"
debug_mode     = false
memory_limit   = 256
cpu_shares     = 256
restart_policy = "unless-stopped"
