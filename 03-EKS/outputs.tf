# Basic outputs for EKS

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "kubeconfig_command" {
  description = "kubectl config command"
  value       = "aws eks update-kubeconfig --region us-east-1 --name guru-eks-cluster"
}
