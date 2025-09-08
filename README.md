# EKS Infrastructure with Autoscaling

A Terraform-based AWS EKS infrastructure with horizontal pod autoscaling and cluster autoscaling capabilities.

## Architecture

```
Internet → ALB (Public Subnets) → EKS Cluster (Private Subnets)
```

- **Foundation Layer**: VPC, subnets, NAT gateway
- **EKS Layer**: Kubernetes cluster with managed node groups
- **Autoscaler Layer**: Cluster autoscaler, HPA, metrics server, ALB integration

## Quick Start

1. **Deploy Foundation**
   ```bash
   cd 01-foundation
   terraform init
   terraform apply
   ```

2. **Deploy EKS**
   ```bash
   cd 03-EKS
   terraform init
   terraform apply
   ```

3. **Deploy Autoscaling**
   ```bash
   cd 04-EKS-Autoscaler
   terraform init
   terraform apply
   ```

4. **Configure kubectl**
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name guru-eks-cluster
   ```

## Demo Application

Access the nginx demo app via the Application Load Balancer:
- URL will be displayed in Terraform outputs after deployment
- Example: `http://k8s-demoapp-xxxxx.us-east-1.elb.amazonaws.com`

## Testing Autoscaling

- **Horizontal Pod Autoscaler**: Scales pods based on CPU/memory usage
- **Cluster Autoscaler**: Adds/removes nodes based on pod scheduling needs

```bash
# Check HPA status
kubectl get hpa -n demo

# Check cluster autoscaler logs
kubectl logs -n kube-system deployment/cluster-autoscaler

# Monitor resources
kubectl top pods -n demo
```

## Components

- **Metrics Server**: Provides resource metrics for HPA
- **Cluster Autoscaler**: Manages node scaling
- **AWS Load Balancer Controller**: Creates and manages ALBs
- **Demo App**: Simple nginx deployment with autoscaling configured

## Cleanup

```bash
# Destroy in reverse order
cd 04-EKS-Autoscaler && terraform destroy
cd ../03-EKS && terraform destroy  
cd ../01-foundation && terraform destroy
```
