# Example usage of the VPC module
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Teams would configure their own backend
  backend "s3" {
    bucket = "team-a-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

# Using your modularized VPC
module "vpc" {
  source = "git::https://github.com/GuruPrasadVishnu/IAC-Simple.git//terraform-modules/vpc?ref=v1.0.0"
  
  name        = var.project_name
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  additional_tags = {
    Team        = "Platform"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Teams can now use the VPC outputs for other resources
resource "aws_security_group" "example" {
  name   = "${var.project_name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr]
  }
}
