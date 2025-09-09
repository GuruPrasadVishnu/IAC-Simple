terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # No backend for now - using local state
  # TODO: move to S3 backend later
}

provider "aws" {
  region = var.region
}
