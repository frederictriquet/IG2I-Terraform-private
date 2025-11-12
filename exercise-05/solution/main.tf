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

# S3 Bucket with enriched tags
resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name

  tags = local.enriched_tags
}

# Optional: Enable versioning conditionally
resource "aws_s3_bucket_versioning" "example" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}
