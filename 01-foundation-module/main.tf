terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "guru-terraform-state-bucket"
    key            = "foundation-module/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module from Terraform Registry
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-module-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # Enable NAT Gateway for private subnets
  enable_nat_gateway = true
  single_nat_gateway = true  # Cost-effective: one NAT for all private subnets
  enable_vpn_gateway = false

  # Enable DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  tags = {
    Project     = var.project_name
    Environment = "demo"
    CreatedBy   = "terraform-module"
  }

  public_subnet_tags = {
    Type = "public"
    "kubernetes.io/role/elb" = "1"  # For AWS Load Balancer Controller
  }

  private_subnet_tags = {
    Type = "private"
    "kubernetes.io/role/internal-elb" = "1"  # For internal load balancers
  }
}
