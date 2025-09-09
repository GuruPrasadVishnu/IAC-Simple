# Variables for the microservices platform
# keeping it simple but professional

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "guru-ms-platform"
}

variable "app_replicas" {
  description = "Initial number of app replicas"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Maximum replicas for autoscaling"
  type        = number
  default     = 8  # Lower max for easier demo
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "Guru"
}

# Component Versions
variable "metrics_server_version" {
  description = "Version of metrics server to install"
  type        = string
  default     = "3.12.1"
}

variable "cluster_autoscaler_chart_version" {
  description = "Version of cluster autoscaler Helm chart to install"
  type        = string
  default     = "9.29.0"
}

variable "aws_load_balancer_controller_version" {
  description = "Version of AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "1.8.1"
}

# Autoscaler Configuration
variable "enable_metrics_server" {
  description = "Enable metrics server (required for HPA)"
  type        = bool
  default     = true
}

variable "cluster_autoscaler_version" {
  description = "Version of cluster autoscaler to install"
  type        = string
  default     = "1.30.0"
}

variable "enable_cluster_autoscaler" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = true
}

variable "enable_hpa" {
  description = "Enable horizontal pod autoscaler"
  type        = bool
  default     = true
}

variable "deploy_demo_app" {
  description = "Deploy simple demo app for testing"
  type        = bool
  default     = true
}
