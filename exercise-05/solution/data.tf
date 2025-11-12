# Data source: Get available availability zones in current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source: Get current AWS account information
data "aws_caller_identity" "current" {}

# Data source: Get current AWS region
data "aws_region" "current" {}

# Data source: Read information about our created S3 bucket
# This demonstrates how to use a data source to read a resource we just created
data "aws_s3_bucket" "existing" {
  bucket = aws_s3_bucket.example.id

  # Ensure the bucket is created before we try to read it
  depends_on = [aws_s3_bucket.example]
}
