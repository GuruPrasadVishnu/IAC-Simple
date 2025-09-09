# Basic outputs for EKS

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "kubeconfig_command" {
  description = "kubectl config command"
  value       = "aws eks update-kubeconfig --region us-east-1 --name guru-eks-cluster"
}
