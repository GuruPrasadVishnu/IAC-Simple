# Get foundation data
data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket = "guru-terraform-state-bucket"  # hardcoded for now
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
