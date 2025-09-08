# EKS Autoscaler Configuration

# Basic configuration
region = "us-east-1"
environment = "dev"
project_name = "ms-platform"
owner = "Guru"

# Remote state configuration
eks_state_bucket = "guru-terraform-state-awnexynj"
eks_state_key = "03-EKS/terraform.tfstate"

# Autoscaler configuration
enable_metrics_server = true
cluster_autoscaler_version = "1.30.0"
enable_cluster_autoscaler = true
enable_hpa = true
deploy_demo_app = true
