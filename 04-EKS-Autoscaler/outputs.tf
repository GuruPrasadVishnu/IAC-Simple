# Outputs for EKS Autoscaler Demo

# Cluster information
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = local.cluster_name
}

output "cluster_region" {
  description = "AWS region of the EKS cluster"
  value       = var.region
}

# Kubeconfig update command
output "kubeconfig_update_command" {
  description = "Command to update kubeconfig for this cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${local.cluster_name}"
}

# IAM Role outputs
output "cluster_autoscaler_role_arn" {
  description = "ARN of the cluster autoscaler IAM role"
  value       = var.enable_cluster_autoscaler ? aws_iam_role.cluster_autoscaler[0].arn : null
}

output "cluster_autoscaler_role_name" {
  description = "Name of the cluster autoscaler IAM role"
  value       = var.enable_cluster_autoscaler ? aws_iam_role.cluster_autoscaler[0].name : null
}

# Component status outputs
output "cluster_autoscaler_deployed" {
  description = "Whether cluster autoscaler is deployed"
  value       = var.enable_cluster_autoscaler
}

output "metrics_server_deployed" {
  description = "Whether metrics server is deployed"
  value       = var.enable_metrics_server
}

output "demo_app_deployed" {
  description = "Whether demo app is deployed"
  value       = var.deploy_demo_app
}

# Demo commands
output "demo_commands" {
  description = "Useful commands for the demo"
  value = {
    kubeconfig    = "aws eks update-kubeconfig --region ${var.region} --name ${local.cluster_name}"
    check_nodes   = "kubectl get nodes"
    check_pods    = "kubectl get pods -n demo"
    check_hpa     = "kubectl get hpa -n demo"
    load_test     = "kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -n demo -- /bin/sh -c \"while sleep 0.01; do wget -q -O- http://demo-app-ingress-nginx-controller; done\""
    watch_hpa     = "kubectl get hpa -n demo --watch"
    watch_pods    = "kubectl get pods -n demo --watch"
    autoscaler_logs = "kubectl logs -n kube-system -l app.kubernetes.io/name=cluster-autoscaler"
  }
}

# Namespace information
output "demo_namespace" {
  description = "Namespace where demo app is deployed"
  value       = var.deploy_demo_app ? "demo" : null
}
