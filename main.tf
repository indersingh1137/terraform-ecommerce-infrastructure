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

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "ecommerce-${var.environment}-vpc"
    Environment = var.environment
    Purpose     = "ecommerce-network"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "ecommerce-${var.environment}-public-subnet"
    Environment = var.environment
    Purpose     = "ecommerce-public-subnet"
  }
}

resource "aws_security_group" "web" {
  name        = "ecommerce-${var.environment}-web-sg"
  description = "Security group for E-Commerce web application"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name        = "ecommerce-${var.environment}-web-sg"
    Environment = var.environment
    Purpose     = "ecommerce-web"
  }
}

data "aws_ssm_parameter" "amazon_linux" { name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" }
resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.amazon_linux.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name        = "ecommerce-${var.environment}-web"
    Environment = var.environment
    Purpose     = "ecommerce-web"
  }
}