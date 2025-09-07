# This module depends on the VPC infrastructure from 01-foundation
# It uses terraform remote state to access VPC outputs

# Remote State Configuration
variable "foundation_state_bucket" {
  description = "S3 bucket name where foundation state is stored"
  type        = string
  default     = "guru-terraform-state-awnexynj"
}

variable "foundation_state_key" {
  description = "S3 key where foundation state is stored"
  type        = string
  default     = "terraform.tfstate"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # Updated to match foundation layer
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"  # Using dev as default to prevent accidents
}

# EKS Configuration
variable "kubernetes_version" {
  description = "Kubernetes version to use for EKS cluster"
  type        = string
  default     = "1.33"  # Default version as of Sept 2025, supports extended features
}

# Node group configuration
variable "desired_nodes" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2  # Starting small to save costs
}

variable "min_nodes" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1  # Need at least one for high availability
}

variable "max_nodes" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4  # Can go higher but watching costs for now
}

# EKS Infrastructure Configuration
variable "availability_zones" {
  description = "List of availability zones to use for EKS cluster"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "ms-platform-eks"
}

variable "project_name" {
  description = "Name of the project (used in resource naming and tags)"
  type        = string
  default     = "ms-platform"
}

variable "owner" {
  description = "Owner of the resources (used in tags)"
  type        = string
  default     = "Guru"
}