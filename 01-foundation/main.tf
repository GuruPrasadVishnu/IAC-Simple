terraform {
  backend "s3" {
    bucket         = "guru-terraform-state-awnexynj"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "guru-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
