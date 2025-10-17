# Local values to avoid repetition and compute derived values
locals {
  # Generate a consistent bucket name used in multiple places
  bucket_name = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"

  # Common tags that will be applied to all resources
  common_tags = {
    Name        = local.bucket_name
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }

  # Merge common tags with user-provided additional tags
  all_tags = merge(local.common_tags, var.additional_tags)

  # Create a resource prefix for consistent naming
  resource_prefix = "${var.project_name}-${var.environment}"

  # Computed values based on configuration
  is_production = var.environment == "Production"
  requires_backup = local.is_production || var.enable_versioning
}
