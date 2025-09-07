aws_region   = "us-east-1"
project_name = "guru"

instance_type = "t2.micro"
ami_id       = "ami-00ca32bbc84273381"

# This will be filled after foundation deployment
foundation_state_bucket = "guru-terraform-state-awnexynj"
foundation_state_key    = "terraform.tfstate"
