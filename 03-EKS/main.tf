# Configure providers for AWS and Kubernetes resources

# EKS Configuration
locals {
  # Use variables for flexible configuration
  azs = var.availability_zones
  # EKS cluster name
  cluster_name = var.cluster_name
  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

# AWS Provider configuration
provider "aws" {
  region = var.region
}

# Get EKS cluster auth data for provider configuration
data "aws_eks_cluster" "main" {
  name = aws_eks_cluster.main.name
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

# Configure Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}
