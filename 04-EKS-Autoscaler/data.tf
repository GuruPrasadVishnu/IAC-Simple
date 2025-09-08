# Data sources to access remote state from other layers

# Foundation layer - VPC, networking, S3 backend
data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket = var.foundation_state_bucket
    key    = var.foundation_state_key
    region = var.region
  }
}

# EKS layer - Kubernetes cluster
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.eks_state_bucket
    key    = var.eks_state_key
    region = var.region
  }
}

# Get current AWS region
data "aws_region" "current" {}

# Get current AWS caller identity
data "aws_caller_identity" "current" {}

# EKS cluster data
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}


locals {
  # EKS cluster information from remote state
  cluster_name     = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_endpoint = data.terraform_remote_state.eks.outputs.cluster_endpoint
  
  # Common tags
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Layer       = "autoscaler"
  }
}
