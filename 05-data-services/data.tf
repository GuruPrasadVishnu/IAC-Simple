# Get foundation infrastructure data
data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket = "guru-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Get EKS cluster data
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "guru-terraform-state-bucket"
    key    = "03-EKS/terraform.tfstate"
    region = "us-east-1"
  }
}
