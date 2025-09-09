# Basic data sources 
# hardcoding some stuff to keep it simple

# Get current region
data "aws_region" "current" {}

# Get current account
data "aws_caller_identity" "current" {}

# EKS cluster info - hardcoded for now
data "aws_eks_cluster" "cluster" {
  name = "guru-eks-cluster"  # TODO: make this dynamic later
}

data "aws_eks_cluster_auth" "cluster" {
  name = "guru-eks-cluster"
}

locals {
  cluster_name = "guru-eks-cluster"
  
  common_tags = {
    Project   = var.project_name
    Owner     = "guru"
    ManagedBy = "terraform"
  }
}
