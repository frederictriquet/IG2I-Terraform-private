locals {
  # Bucket name combining prefix, region, and random suffix
  bucket_name = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"

  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Exercise    = "05"
  }

  # Resource owner using AWS account information
  resource_owner = "AWS-Account-${data.aws_caller_identity.current.account_id}"

  # Enriched tags using data from AWS data sources
  enriched_tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Region     = data.aws_region.current.name
      AccountId  = data.aws_caller_identity.current.account_id
      Owner      = local.resource_owner
      ZoneCount  = length(data.aws_availability_zones.available.names)
    }
  )
}
