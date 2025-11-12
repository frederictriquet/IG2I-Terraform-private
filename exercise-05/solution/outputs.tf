# ========================================
# S3 Bucket Outputs
# ========================================

output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.example.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.example.arn
}

output "bucket_name" {
  description = "The complete name of the S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "bucket_region" {
  description = "The AWS region where the bucket is located"
  value       = aws_s3_bucket.example.region
}

output "bucket_domain_name" {
  description = "The bucket domain name (for website hosting or CloudFront)"
  value       = aws_s3_bucket.example.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.example.bucket_regional_domain_name
}

output "bucket_tags" {
  description = "All tags applied to the S3 bucket"
  value       = aws_s3_bucket.example.tags_all
}

# ========================================
# AWS Account and Region Information
# ========================================

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
  sensitive   = true
}

output "caller_arn" {
  description = "ARN of the AWS caller identity"
  value       = data.aws_caller_identity.current.arn
  sensitive   = true
}

output "current_region" {
  description = "Current AWS region"
  value       = data.aws_region.current.name
}

output "region_description" {
  description = "Description of the current AWS region"
  value       = data.aws_region.current.description
}

# ========================================
# Availability Zones
# ========================================

output "available_zones" {
  description = "List of available availability zones in the current region"
  value       = data.aws_availability_zones.available.names
}

output "available_zones_count" {
  description = "Number of available zones in the current region"
  value       = length(data.aws_availability_zones.available.names)
}

# ========================================
# Data Source Outputs (reading existing bucket)
# ========================================

output "existing_bucket_region" {
  description = "Region of the bucket (from data source)"
  value       = data.aws_s3_bucket.existing.region
}

output "existing_bucket_domain_name" {
  description = "Domain name of the bucket (from data source)"
  value       = data.aws_s3_bucket.existing.bucket_domain_name
}

output "existing_bucket_hosted_zone_id" {
  description = "Route 53 hosted zone ID for the bucket"
  value       = data.aws_s3_bucket.existing.hosted_zone_id
}

# ========================================
# Computed Values
# ========================================

output "bucket_url" {
  description = "Full S3 URL for the bucket"
  value       = "s3://${aws_s3_bucket.example.bucket}"
}

output "bucket_console_url" {
  description = "AWS Console URL for the bucket"
  value       = "https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.example.bucket}"
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = var.enable_versioning
}
