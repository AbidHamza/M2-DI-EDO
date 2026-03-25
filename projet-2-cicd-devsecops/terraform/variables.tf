# =============================================================================
# Terraform Variables
# =============================================================================
# All configurable parameters for the Finance App infrastructure.
# Values are set per environment via .tfvars files.
# =============================================================================

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "app_name" {
  description = "Application name (used for container and network naming)"
  type        = string
  default     = "finance-app"
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = "finance-app:latest"
}

variable "app_port" {
  description = "External port to expose the application"
  type        = number
  default     = 5000

  validation {
    condition     = var.app_port > 0 && var.app_port < 65536
    error_message = "Port must be between 1 and 65535."
  }
}

variable "app_internal_port" {
  description = "Internal port inside the container"
  type        = number
  default     = 5000
}

variable "app_replicas" {
  description = "Number of application container replicas"
  type        = number
  default     = 1

  validation {
    condition     = var.app_replicas >= 1 && var.app_replicas <= 5
    error_message = "Replicas must be between 1 and 5."
  }
}

variable "log_level" {
  description = "Application log level (DEBUG, INFO, WARNING, ERROR)"
  type        = string
  default     = "INFO"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARNING", "ERROR"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARNING, ERROR."
  }
}

variable "debug_mode" {
  description = "Enable debug mode (only for dev environment)"
  type        = bool
  default     = false
}

variable "memory_limit" {
  description = "Container memory limit in MB"
  type        = number
  default     = 256
}

variable "cpu_shares" {
  description = "CPU shares for the container (relative weight)"
  type        = number
  default     = 256
}

variable "restart_policy" {
  description = "Container restart policy"
  type        = string
  default     = "unless-stopped"

  validation {
    condition     = contains(["no", "always", "unless-stopped", "on-failure"], var.restart_policy)
    error_message = "Restart policy must be: no, always, unless-stopped, or on-failure."
  }
}
