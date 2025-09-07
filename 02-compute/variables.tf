variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project (used in resource naming)"
  type        = string
  default     = "guru"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-00ca32bbc84273381"
}

variable "foundation_state_bucket" {
  description = "S3 bucket name where foundation state is stored"
  type        = string
}

variable "foundation_state_key" {
  description = "S3 key where foundation state is stored"
  type        = string
  default     = "terraform.tfstate"
}
