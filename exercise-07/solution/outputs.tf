# ========================================
# Bucket Information
# ========================================

output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.conditional.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.conditional.arn
}

# ========================================
# Configuration Summary
# ========================================

output "bucket_configuration" {
  description = "Complete summary of bucket configuration"
  value = {
    bucket_name         = aws_s3_bucket.conditional.id
    environment         = var.environment
    versioning          = local.versioning_enabled
    encryption          = local.encryption_enabled
    encryption_type     = local.encryption_type
    public_access_blocked = var.block_public_access
    lifecycle_rules     = length(var.lifecycle_rules)
    cors_enabled        = length(var.cors_rules) > 0
    logging_enabled     = local.require_compliance
    is_production       = local.is_production
    require_compliance  = local.require_compliance
    retention_days      = local.retention_days
  }
}

# ========================================
# Conditional Resources Status
# ========================================

output "conditional_resources_created" {
  description = "Which optional resources were created"
  value = {
    versioning          = local.versioning_enabled ? "enabled" : "disabled"
    encryption          = local.encryption_enabled ? "enabled" : "disabled"
    public_access_block = var.block_public_access ? "enabled" : "disabled"
    lifecycle_rules     = length(var.lifecycle_rules) > 0 ? "configured" : "not configured"
    cors_rules          = length(var.cors_rules) > 0 ? "configured" : "not configured"
    logging             = local.require_compliance ? "enabled" : "disabled"
  }
}

# ========================================
# Environment-Specific Information
# ========================================

output "environment_info" {
  description = "Environment-specific configuration details"
  value = {
    environment_type     = var.environment
    is_production        = local.is_production
    is_staging           = local.is_staging
    is_development       = local.is_development
    requires_compliance  = local.require_compliance
    retention_days       = local.retention_days
    lifecycle_days       = local.lifecycle_days
    encryption_type      = local.encryption_type
  }
}

# ========================================
# Validation and Compliance
# ========================================

output "validation_checks" {
  description = "Validation checks for production compliance"
  value       = local.production_checks
}

output "validation_status" {
  description = "Overall validation status"
  value       = local.validation_status
}

# ========================================
# Features Summary
# ========================================

output "enabled_features" {
  description = "Summary of all enabled features"
  value       = local.enabled_features
}

output "enabled_features_count" {
  description = "Number of enabled features"
  value       = local.enabled_features_count
}

output "security_posture" {
  description = "Security posture assessment"
  value = {
    level = (
      local.enabled_features_count >= 5 ? "High" :
      local.enabled_features_count >= 3 ? "Medium" :
      "Low"
    )
    score = local.enabled_features_count
    max_score = length(local.enabled_features)
    recommendations = local.enabled_features_count < 4 ? [
      "Consider enabling more security features",
      "Versioning recommended for data protection",
      "Encryption recommended for compliance"
    ] : ["Security posture is good"]
  }
}

# ========================================
# Lifecycle Configuration Details
# ========================================

output "lifecycle_configuration" {
  description = "Details of lifecycle rules if configured"
  value = length(var.lifecycle_rules) > 0 ? {
    rules_count = length(var.lifecycle_rules)
    rules = [
      for rule in var.lifecycle_rules : {
        id              = rule.id
        enabled         = rule.enabled
        expiration_days = rule.expiration_days
        has_transition  = rule.transition_days != null
      }
    ]
  } : null
}

# ========================================
# CORS Configuration Details
# ========================================

output "cors_configuration" {
  description = "Details of CORS rules if configured"
  value = length(var.cors_rules) > 0 ? {
    rules_count = length(var.cors_rules)
    rules = [
      for rule in var.cors_rules : {
        allowed_methods = rule.allowed_methods
        allowed_origins = rule.allowed_origins
        max_age_seconds = rule.max_age_seconds
      }
    ]
  } : null
}

# ========================================
# Tags Applied
# ========================================

output "applied_tags" {
  description = "All tags applied to the bucket"
  value       = local.comprehensive_tags
}
