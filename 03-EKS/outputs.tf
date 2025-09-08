# Infrastructure outputs (referencing VPC from foundation layer)
output "vpc_id" {
  description = "VPC ID from foundation layer"
  value       = local.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs from foundation layer"
  value       = local.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs from foundation layer"
  value       = local.public_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID from foundation layer"
  value       = local.nat_gateway_id
}

# EKS cluster outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "Kubernetes version running in the cluster"
  value       = aws_eks_cluster.main.version
}

output "kubeconfig_command" {
  description = "Command to configure kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.main.name}"
}

output "node_group_arn" {
  description = "ARN of the node group"
  value       = aws_eks_node_group.main.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

# OIDC Identity Provider outputs
output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_oidc_issuer_arn" {
  description = "The ARN of the OIDC Identity Provider for the cluster"
  value       = aws_iam_openid_connect_provider.eks.arn
}
