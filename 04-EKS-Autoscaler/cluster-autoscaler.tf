# Cluster Autoscaler Helm Chart - References IAM role from iam-roles.tf

resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_chart_version
  namespace  = "kube-system"

  set {
    name  = "autoDiscovery.clusterName"
    value = local.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler[0].arn
  }

  # Auto-discovery tags
  set {
    name  = "autoDiscovery.tags[0]"
    value = "k8s.io/cluster-autoscaler/enabled"
  }

  set {
    name  = "autoDiscovery.tags[1]"
    value = "k8s.io/cluster-autoscaler/${local.cluster_name}"
  }

  # Scaling configuration
  set {
    name  = "extraArgs.scale-down-delay-after-add"
    value = "10m"
  }

  set {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "10m"
  }

  set {
    name  = "extraArgs.skip-nodes-with-local-storage"
    value = "false"
  }

  set {
    name  = "extraArgs.balance-similar-node-groups"
    value = "true"
  }

  depends_on = [
    aws_iam_role_policy.cluster_autoscaler,
    helm_release.metrics_server
  ]
}