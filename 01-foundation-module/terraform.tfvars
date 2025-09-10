# Module-based foundation config
region       = "us-east-1"
project_name = "guru-module"
vpc_cidr     = "10.1.0.0/16"

# Subnet configuration (different from original)
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
