# 1. Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# 2. Provider Configuration
provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

# 3. Resource Configuration
resource "aws_s3_bucket" "product_assets" {
  bucket = local.bucket_name
  tags = {
    Environment = "dev"
    Purpose     = "product-assets"
  }
}