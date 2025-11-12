locals {
  # Common tags applied to all resources
  common_tags = {
    Project     = "Terraform Training"
    Exercise    = "06"
    ManagedBy   = "Terraform"
    Environment = var.environment
  }

  # Create a unified map of all buckets across all creation methods
  all_buckets = merge(
    # Buckets created with count
    { for i, b in aws_s3_bucket.multiple : "count-${i}" => b.id },
    # Buckets created with for_each (set)
    { for k, b in aws_s3_bucket.foreach_set : "set-${k}" => b.id },
    # Buckets created with for_each (map)
    { for k, b in aws_s3_bucket.configured : "config-${k}" => b.id }
  )

  # Filter only production buckets
  production_buckets = {
    for k, b in aws_s3_bucket.configured : k => b.id
    if b.tags["Environment"] == "production"
  }

  # Count total buckets
  total_bucket_count = (
    length(aws_s3_bucket.multiple) +
    length(aws_s3_bucket.foreach_set) +
    length(aws_s3_bucket.configured)
  )
}
