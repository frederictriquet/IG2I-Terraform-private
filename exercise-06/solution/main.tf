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

# ========================================
# Part 1: Using count
# ========================================

# Create random suffixes using count
resource "random_id" "bucket_suffix" {
  count       = var.bucket_count
  byte_length = 4
}

# Create multiple S3 buckets using count
resource "aws_s3_bucket" "multiple" {
  count  = var.bucket_count
  bucket = "${var.bucket_prefix}-count-${count.index}-${random_id.bucket_suffix[count.index].hex}"

  tags = merge(
    local.common_tags,
    {
      Name   = "Bucket-Count-${count.index}"
      Index  = count.index
      Method = "count"
    }
  )
}

# ========================================
# Part 2: Using for_each with a set
# ========================================

# Random suffix for each bucket in the set
resource "random_id" "foreach_suffix" {
  for_each    = var.bucket_names
  byte_length = 4
}

# Create buckets using for_each with a set
resource "aws_s3_bucket" "foreach_set" {
  for_each = var.bucket_names

  bucket = "${var.bucket_prefix}-${each.key}-${random_id.foreach_suffix[each.key].hex}"

  tags = merge(
    local.common_tags,
    {
      Name        = "Bucket-${each.key}"
      Environment = each.key
      Method      = "for_each-set"
    }
  )
}

# ========================================
# Part 3: Using for_each with a map
# ========================================

# Random suffix for each configured bucket
resource "random_id" "config_suffix" {
  for_each    = var.bucket_configs
  byte_length = 4
}

# Create buckets with different configurations
resource "aws_s3_bucket" "configured" {
  for_each = var.bucket_configs

  bucket = "${var.bucket_prefix}-${each.key}-${random_id.config_suffix[each.key].hex}"

  tags = merge(
    local.common_tags,
    {
      Name        = each.key
      Environment = each.value.environment
      Versioning  = tostring(each.value.versioning)
      Method      = "for_each-map"
    }
  )
}

# Apply versioning conditionally based on configuration
resource "aws_s3_bucket_versioning" "configured" {
  # Only create versioning resource for buckets where versioning = true
  for_each = {
    for k, v in var.bucket_configs : k => v
    if v.versioning == true
  }

  bucket = aws_s3_bucket.configured[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}
