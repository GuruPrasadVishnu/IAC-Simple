# Outputs for microservices platform

output "cluster_name" {
  description = "EKS cluster name"
  value       = local.cluster_name
}

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region us-east-1 --name guru-eks-cluster"
}

output "namespace" {
  description = "Microservices namespace"
  value       = "microservices-platform"
}

output "frontend_service" {
  description = "Frontend service name"
  value       = "frontend-service"
}

output "api_service" {
  description = "API service name" 
  value       = "api-service"
}
