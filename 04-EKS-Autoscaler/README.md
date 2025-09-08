# EKS Autoscaler Demo

This layer adds **Cluster Autoscaler** and **Horizontal Pod Autoscaler (HPA)** to your existing EKS cluster for automatic scaling capabilities.

## What This Demo Shows

### 1. **Metrics Server**

- Collects resource metrics from kubelets
- Required for HPA to function properly
- Enables `kubectl top` commands
- Provides CPU/memory metrics for scaling decisions

### 2. **Cluster Autoscaler**

- Automatically adds/removes worker nodes based on pod demand
- Scales nodes up when pods can't be scheduled
- Scales nodes down when they're underutilized
- **Note**: Uses pod scheduling status, not metrics

### 3. **Horizontal Pod Autoscaler (HPA)**

- Automatically scales pod replicas based on CPU/memory usage
- **Requires Metrics Server** to collect resource metrics
- Monitors metrics and adjusts deployment replica count
- Includes a demo NGINX application for testing

## Prerequisites

- Foundation layer deployed (`01-foundation`)
- EKS cluster deployed (`03-EKS`)
- `kubectl` configured to access your cluster

## Quick Deploy

```bash
# Navigate to autoscaler directory
cd 04-EKS-Autoscaler

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

## Demo Steps

### 1. Check Initial State
```bash
# Check current nodes
kubectl get nodes

# Verify metrics server is running
kubectl get deployment metrics-server -n kube-system

# Test metrics collection (should show CPU/Memory usage)
kubectl top nodes
kubectl top pods -n autoscaler-demo

# Check demo pods
kubectl get pods -n autoscaler-demo

# Check HPA status (should show "unknown" initially until metrics are collected)
kubectl get hpa -n autoscaler-demo
```

### 2. Test Horizontal Pod Autoscaler
```bash
# Generate CPU load (run in separate terminal)
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -n autoscaler-demo -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://demo-app-service; done"

# Watch HPA scale pods (in another terminal)
kubectl get hpa -n autoscaler-demo --watch

# Watch pods scaling
kubectl get pods -n autoscaler-demo --watch
```

### 3. Test Cluster Autoscaler
```bash
# Scale up demo app to trigger node scaling
kubectl scale deployment demo-app --replicas=20 -n autoscaler-demo

# Watch for new nodes being added
kubectl get nodes --watch

# Check cluster autoscaler logs
kubectl logs -n kube-system -l app.kubernetes.io/name=cluster-autoscaler
```

### 4. Scale Down
```bash
# Stop load generator (Ctrl+C)

# Scale down demo app
kubectl scale deployment demo-app --replicas=2 -n autoscaler-demo

# Watch HPA scale down pods
kubectl get hpa -n autoscaler-demo --watch

# Watch nodes scale down (takes ~10 minutes)
kubectl get nodes --watch
```

## Key Components

### Cluster Autoscaler
- **Location**: `kube-system` namespace
- **Chart**: Official Kubernetes autoscaler Helm chart
- **IAM Role**: Attached via service account with IRSA
- **Permissions**: Can modify Auto Scaling Groups

### Demo Application
- **Application**: NGINX web server
- **Namespace**: `autoscaler-demo`
- **Resources**: CPU/Memory requests and limits set
- **HPA Target**: 70% CPU, 80% Memory
- **Scaling**: 2-10 replicas

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Foundation    │───▶│    EKS Cluster   │───▶│   Autoscaler    │
│   (Networking)  │    │   (Kubernetes)   │    │   (Scaling)     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Configuration

All settings in `terraform.tfvars`:
- `enable_cluster_autoscaler`: Enable/disable cluster autoscaler
- `enable_hpa`: Enable/disable HPA demo
- `cluster_autoscaler_version`: Helm chart version

## Troubleshooting

### Check Cluster Autoscaler
```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=cluster-autoscaler
kubectl logs -n kube-system -l app.kubernetes.io/name=cluster-autoscaler
```

### Check HPA
```bash
kubectl describe hpa demo-app-hpa -n autoscaler-demo
kubectl top pods -n autoscaler-demo
```

### Check Metrics Server
```bash
kubectl get deployment metrics-server -n kube-system
kubectl logs -n kube-system -l k8s-app=metrics-server
```

## Clean Up

```bash
terraform destroy
```

**Note**: This will remove autoscaler components but keep the EKS cluster and foundation infrastructure.

## Demo Script Summary

1. **Show current state** - nodes, pods, HPA
2. **Generate load** - CPU stress to trigger HPA
3. **Scale deployment** - trigger cluster autoscaler
4. **Monitor scaling** - watch both pod and node scaling
5. **Scale down** - demonstrate both scale-down behaviors
6. **Explain benefits** - cost optimization, performance, reliability
