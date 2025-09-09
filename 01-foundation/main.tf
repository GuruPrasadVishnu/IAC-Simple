terraform {
  # TODO: move this to variables later
  backend "s3" {
    bucket = "guru-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"    
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  
    }
  }
}

provider "aws" {
  region = var.region  
}
