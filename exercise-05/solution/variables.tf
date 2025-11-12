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
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "ig2i-terraform"

  validation {
    condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 37
    error_message = "Bucket prefix must be between 3 and 37 characters."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-training"
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
