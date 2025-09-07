# Data source to read foundation layer outputs
data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket = var.foundation_state_bucket
    key    = var.foundation_state_key
    region = var.aws_region
  }
}

# Local values for easier reference
locals {
  vpc_id             = data.terraform_remote_state.foundation.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.foundation.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.foundation.outputs.private_subnet_ids
  project_name       = data.terraform_remote_state.foundation.outputs.project_name
}
