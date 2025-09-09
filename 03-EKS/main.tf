# Basic provider configuration

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Using remote state
  backend "s3" {
    bucket = "guru-terraform-state-bucket"
    key    = "03-EKS/terraform.tfstate"
    region = "us-east-1"
  }
}

# AWS Provider
provider "aws" {
  region = var.region
}

# Get foundation state for VPC info
data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket = "guru-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Common locals
locals {
  common_tags = {
    Project   = "guru-ms-platform"
    Owner     = "guru"
    ManagedBy = "terraform"
  }
}
