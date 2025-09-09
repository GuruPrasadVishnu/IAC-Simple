# Basic foundation config
region       = "us-east-1"
project_name = "ms-platform"
vpc_cidr     = "10.0.0.0/16"

# Subnet configuration
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
