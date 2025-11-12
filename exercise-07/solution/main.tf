terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Random suffix for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ========================================
# Main S3 Bucket (always created)
# ========================================

resource "aws_s3_bucket" "conditional" {
  bucket = "${var.bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = local.comprehensive_tags
}

# ========================================
# Conditional Features
# ========================================

# Versioning (conditional - uses local logic)
resource "aws_s3_bucket_versioning" "conditional" {
  count  = local.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.conditional.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption (conditional - uses local logic)
resource "aws_s3_bucket_server_side_encryption_configuration" "conditional" {
  count  = local.encryption_enabled ? 1 : 0
  bucket = aws_s3_bucket.conditional.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = local.encryption_type == "aws:kms" ? "aws:kms" : "AES256"
    }
  }
}

# Public access block (conditional)
resource "aws_s3_bucket_public_access_block" "conditional" {
  count  = var.block_public_access ? 1 : 0
  bucket = aws_s3_bucket.conditional.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================================
# Dynamic Blocks - Lifecycle Configuration
# ========================================

resource "aws_s3_bucket_lifecycle_configuration" "conditional" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.conditional.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      expiration {
        days = rule.value.expiration_days
      }

      # Optional transition block (created only if transition_days is set)
      dynamic "transition" {
        for_each = rule.value.transition_days != null ? [1] : []
        content {
          days          = rule.value.transition_days
          storage_class = rule.value.transition_storage_class
        }
      }
    }
  }
}

# ========================================
# Dynamic Blocks - CORS Configuration
# ========================================

resource "aws_s3_bucket_cors_configuration" "conditional" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.conditional.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# ========================================
# Logging (conditional - only for prod/staging)
# ========================================

resource "aws_s3_bucket_logging" "conditional" {
  count  = local.require_compliance ? 1 : 0
  bucket = aws_s3_bucket.conditional.id

  target_bucket = aws_s3_bucket.conditional.id
  target_prefix = "logs/"
}
