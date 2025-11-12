locals {
  # ========================================
  # Environment Detection
  # ========================================

  is_production  = var.environment == "prod"
  is_staging     = var.environment == "staging"
  is_development = var.environment == "dev"
  is_public      = var.environment == "public"

  # ========================================
  # Compliance and Security Requirements
  # ========================================

  # Compliance required for prod and staging
  require_compliance = contains(["prod", "staging"], var.environment)

  # Force security features in production
  versioning_enabled = local.is_production ? true : var.enable_versioning
  encryption_enabled = local.is_production ? true : var.enable_encryption

  # Determine encryption type based on environment
  encryption_type = (
    local.is_production ? "aws:kms" :
    local.require_compliance ? "AES256" :
    var.enable_encryption ? "AES256" : "none"
  )

  # ========================================
  # Lifecycle and Retention Settings
  # ========================================

  # Retention period depends on environment
  retention_days = (
    local.is_production ? 365 :
    local.is_staging ? 180 :
    90
  )

  # Determine lifecycle days
  lifecycle_days = (
    local.is_production ? 90 :
    local.is_staging ? 60 :
    30
  )

  # ========================================
  # Tagging Strategy
  # ========================================

  # Base tags
  bucket_tags = {
    Name        = "${var.bucket_prefix}-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Exercise    = "07"
    Versioning  = tostring(local.versioning_enabled)
    Encryption  = tostring(local.encryption_enabled)
  }

  # Production-specific tags
  production_tags = local.is_production ? {
    Critical   = "true"
    Compliance = "required"
    Backup     = "enabled"
    SLA        = "99.9%"
  } : {}

  # Staging-specific tags
  staging_tags = local.is_staging ? {
    Compliance = "required"
    Testing    = "true"
  } : {}

  # Comprehensive tags combining all conditional tags
  comprehensive_tags = merge(
    local.bucket_tags,
    local.production_tags,
    local.staging_tags,
    var.enable_versioning ? { Versioned = "true" } : {},
    local.is_public ? { Public = "true" } : { Public = "false" }
  )

  # ========================================
  # Production Validation Checks
  # ========================================

  production_checks = {
    versioning = local.is_production && !local.versioning_enabled ?
      "ERROR: Versioning must be enabled in production" : "OK"
    encryption = local.is_production && !local.encryption_enabled ?
      "ERROR: Encryption must be enabled in production" : "OK"
    public_access = local.is_production && !var.block_public_access ?
      "ERROR: Public access must be blocked in production" : "OK"
    lifecycle_rules = local.is_production && length(var.lifecycle_rules) == 0 ?
      "WARNING: Lifecycle rules recommended for production" : "OK"
  }

  # Overall validation status
  validation_status = alltrue([
    for check in values(local.production_checks) : !startswith(check, "ERROR")
  ]) ? "All checks passed" : "Some checks failed"

  # ========================================
  # Feature Summary
  # ========================================

  enabled_features = {
    versioning         = local.versioning_enabled
    encryption         = local.encryption_enabled
    public_access_block = var.block_public_access
    lifecycle_rules    = length(var.lifecycle_rules) > 0
    cors_rules         = length(var.cors_rules) > 0
    logging           = local.require_compliance
  }

  # Count enabled features
  enabled_features_count = length([
    for k, v in local.enabled_features : k if v == true
  ])
}
