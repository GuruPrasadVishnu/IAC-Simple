# Provider configurations for EKS Autoscaler

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
  }

  # Backend configuration for remote state
  backend "s3" {
    bucket         = "guru-terraform-state-awnexynj"  # TODO: Make this configurable
    key            = "04-EKS-Autoscaler/terraform.tfstate"
    region         = "us-east-1"                      # TODO: Make this configurable
    dynamodb_table = "guru-terraform-locks"          # TODO: Make this configurable
    encrypt        = true
  }
}

# AWS Provider
provider "aws" {
  region = var.region
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Helm Provider
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}