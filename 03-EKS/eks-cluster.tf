# EKS Cluster setup

# Basic security group for cluster
resource "aws_security_group" "eks_cluster" {
  name        = "guru-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = data.terraform_remote_state.foundation.outputs.vpc_id

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # K8s API access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: restrict this later
  }

  tags = {
    Name = "guru-eks-cluster-sg"
  }
}

# EKS cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = "1.30"  # hardcoded for now
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_cluster.id]
    subnet_ids         = data.terraform_remote_state.foundation.outputs.private_subnet_ids
    
    endpoint_private_access = true
    endpoint_public_access  = true  # need this for kubectl access
  }

  # Make sure IAM role is ready
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "guru-eks-cluster"
  }
}
