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
  description = "Prefix for bucket names"
  type        = string
  default     = "ig2i-ex06"

  validation {
    condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 20
    error_message = "Bucket prefix must be between 3 and 20 characters."
  }
}

variable "environment" {
  description = "Default environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# ========================================
# Variables for count example
# ========================================

variable "bucket_count" {
  description = "Number of buckets to create with count"
  type        = number
  default     = 3

  validation {
    condition     = var.bucket_count > 0 && var.bucket_count <= 10
    error_message = "Bucket count must be between 1 and 10."
  }
}

# ========================================
# Variables for for_each with set
# ========================================

variable "bucket_names" {
  description = "Set of bucket environment names to create"
  type        = set(string)
  default     = ["dev", "staging", "prod"]

  validation {
    condition     = length(var.bucket_names) > 0
    error_message = "At least one bucket name must be provided."
  }
}

# ========================================
# Variables for for_each with map
# ========================================

variable "bucket_configs" {
  description = "Map of bucket configurations with versioning and environment settings"
  type = map(object({
    versioning  = bool
    environment = string
  }))
  default = {
    "app-dev" = {
      versioning  = false
      environment = "development"
    }
    "app-staging" = {
      versioning  = true
      environment = "staging"
    }
    "app-prod" = {
      versioning  = true
      environment = "production"
    }
  }

  validation {
    condition     = length(var.bucket_configs) > 0
    error_message = "At least one bucket configuration must be provided."
  }
}
