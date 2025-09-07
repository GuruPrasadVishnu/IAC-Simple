# EKS Layer Configuration
region = "us-east-1"
environment = "dev"

# EKS Infrastructure Configuration
availability_zones = ["us-east-1a", "us-east-1b"]
cluster_name = "guru-platform-eks"
project_name = "guru"
owner = "Guru"

# Remote State Configuration
foundation_state_bucket = "guru-terraform-state-awnexynj"
foundation_state_key    = "terraform.tfstate"

# EKS Configuration
kubernetes_version = "1.33"

# Node Group Configuration
desired_nodes = 2
min_nodes     = 1
max_nodes     = 4
