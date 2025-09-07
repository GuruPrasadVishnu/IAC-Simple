# VPC Data Sources - Using outputs from the networking layer (01-foundation)
# This file contains local references to VPC resources created in the networking layer

# Data source to get VPC outputs from the foundation layer
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.foundation_state_bucket
    key    = var.foundation_state_key
    region = var.region
  }
}

locals {
  # VPC information from remote state
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  nat_gateway_id     = data.terraform_remote_state.vpc.outputs.nat_gateway_id
}
