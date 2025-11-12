variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-3"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be in the format: xx-xxxx-x (e.g., eu-west-3)."
  }
}

variable "bucket_prefix" {
  description = "Prefix for bucket name"
  type        = string
  default     = "ig2i-ex07"

  validation {
    condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 20
    error_message = "Bucket prefix must be between 3 and 20 characters."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod, public)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "public"], var.environment)
    error_message = "Environment must be dev, staging, prod, or public."
  }
}

# ========================================
# Boolean Feature Flags
# ========================================

variable "enable_versioning" {
  description = "Enable versioning on the bucket (will be forced to true for production)"
  type        = bool
  default     = false
}

variable "enable_encryption" {
  description = "Enable server-side encryption (will be forced to true for production)"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block all public access to the bucket (recommended: true)"
  type        = bool
  default     = true
}

# ========================================
# Lifecycle Rules Configuration
# ========================================

variable "lifecycle_rules" {
  description = "List of lifecycle rules to apply to the bucket"
  type = list(object({
    id                       = string
    enabled                  = bool
    expiration_days          = number
    transition_days          = optional(number)
    transition_storage_class = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      rule.expiration_days > 0 &&
      (rule.transition_days == null || rule.transition_days > 0)
    ])
    error_message = "Expiration and transition days must be positive numbers."
  }
}

# ========================================
# CORS Rules Configuration
# ========================================

variable "cors_rules" {
  description = "List of CORS rules for the bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    max_age_seconds = optional(number, 3000)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.cors_rules :
      length(rule.allowed_methods) > 0 &&
      length(rule.allowed_origins) > 0
    ])
    error_message = "Each CORS rule must have at least one allowed method and origin."
  }
}
