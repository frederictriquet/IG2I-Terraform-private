# ========================================
# Outputs for count-based buckets
# ========================================

output "bucket_names_count" {
  description = "List of all bucket names created with count"
  value       = aws_s3_bucket.multiple[*].id
}

output "bucket_arns_count" {
  description = "List of all bucket ARNs created with count"
  value       = aws_s3_bucket.multiple[*].arn
}

output "first_bucket_count" {
  description = "Name of the first bucket created with count"
  value       = length(aws_s3_bucket.multiple) > 0 ? aws_s3_bucket.multiple[0].id : null
}

# ========================================
# Outputs for for_each with set
# ========================================

output "foreach_bucket_names" {
  description = "Map of bucket names from for_each with set"
  value       = { for k, v in aws_s3_bucket.foreach_set : k => v.id }
}

output "foreach_bucket_arns" {
  description = "Map of bucket ARNs from for_each with set"
  value       = { for k, v in aws_s3_bucket.foreach_set : k => v.arn }
}

output "prod_bucket_set" {
  description = "Production bucket name from for_each set"
  value       = contains(var.bucket_names, "prod") ? aws_s3_bucket.foreach_set["prod"].id : null
}

# ========================================
# Outputs for for_each with map
# ========================================

output "configured_buckets" {
  description = "Map of configured buckets with their properties"
  value = {
    for k, v in aws_s3_bucket.configured : k => {
      id          = v.id
      arn         = v.arn
      versioning  = var.bucket_configs[k].versioning
      environment = var.bucket_configs[k].environment
    }
  }
}

output "versioned_buckets" {
  description = "List of buckets with versioning enabled"
  value = [
    for k, v in var.bucket_configs : aws_s3_bucket.configured[k].id
    if v.versioning == true
  ]
}

# ========================================
# Combined outputs
# ========================================

output "all_bucket_arns" {
  description = "All bucket ARNs from all creation methods"
  value = concat(
    aws_s3_bucket.multiple[*].arn,
    [for b in aws_s3_bucket.foreach_set : b.arn],
    [for b in aws_s3_bucket.configured : b.arn]
  )
}

output "all_bucket_names" {
  description = "All bucket names from all creation methods"
  value = concat(
    aws_s3_bucket.multiple[*].id,
    [for b in aws_s3_bucket.foreach_set : b.id],
    [for b in aws_s3_bucket.configured : b.id]
  )
}

output "total_bucket_count" {
  description = "Total number of all buckets created"
  value       = local.total_bucket_count
}

output "all_buckets_map" {
  description = "Map of all buckets with categorized keys"
  value       = local.all_buckets
}

# ========================================
# Filtered outputs
# ========================================

output "production_buckets" {
  description = "Only production environment buckets"
  value       = local.production_buckets
}

output "buckets_by_method" {
  description = "Buckets grouped by creation method"
  value = {
    count_method    = length(aws_s3_bucket.multiple)
    foreach_set     = length(aws_s3_bucket.foreach_set)
    foreach_map     = length(aws_s3_bucket.configured)
    total          = local.total_bucket_count
  }
}

# ========================================
# Detailed information
# ========================================

output "bucket_details" {
  description = "Detailed information about all buckets"
  value = {
    count_buckets = [
      for i, b in aws_s3_bucket.multiple : {
        index  = i
        name   = b.id
        arn    = b.arn
        method = "count"
      }
    ]
    set_buckets = [
      for k, b in aws_s3_bucket.foreach_set : {
        key    = k
        name   = b.id
        arn    = b.arn
        method = "for_each-set"
      }
    ]
    map_buckets = [
      for k, b in aws_s3_bucket.configured : {
        key         = k
        name        = b.id
        arn         = b.arn
        method      = "for_each-map"
        versioning  = var.bucket_configs[k].versioning
        environment = var.bucket_configs[k].environment
      }
    ]
  }
}
