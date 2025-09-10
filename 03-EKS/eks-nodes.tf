# Worker nodes configuration

# Node group for the EKS cluster
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = aws_iam_role.eks_workers.arn
  subnet_ids      = data.terraform_remote_state.foundation.outputs.private_subnet_ids
  instance_types  = [var.node_instance_type]
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 8   # increased for microservices workloads
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_registry_policy,
  ]

  tags = {
    Name = "guru-eks-nodes"
    Environment = "dev"
    Purpose = "guru-microservices-platform"
  }
}
