terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  # Backend configuration for remote state
  backend "s3" {
    bucket         = "guru-terraform-state-awnexynj"
    key            = "03-EKS/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "guru-terraform-locks"
    encrypt        = true
  }
}
