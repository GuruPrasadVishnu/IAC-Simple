# Infrastructure as Code Project

Simple AWS infrastructure setup using Terraform. Built this to demonstrate different patterns - from basic EC2 to full EKS with autoscaling.

## What's Inside

- **01-foundation/** - The basics: VPC, subnets, NAT gateway
- **02-compute/** - Simple web server behind a load balancer (private subnet for security)
- **03-EKS/** - Kubernetes cluster setup
- **04-EKS-Autoscaler/** - EKS with horizontal pod autoscaling (the cool stuff!)

## How to Use

Deploy in this order (each folder has its own README):

1. `01-foundation/` - Sets up the network
2. `02-compute/` OR `03-EKS/` - Pick your poison
3. `04-EKS-Autoscaler/` - Only if you did EKS first

## Quick Start

```bash
# Set up AWS credentials first
aws configure

# Then in each directory:
terraform init
terraform plan
terraform apply
```

Built with ❤️ and lots of coffee ☕
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name guru-eks-cluster
   ```

## Accessing the platform

The frontend service should be available through the load balancer. Check terraform output for the URL.

## Testing autoscaling

1. Check current pods:
   ```bash
   kubectl get pods -n microservices-platform
   ```

2. Generate some load to test HPA:
   ```bash
   kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh
   # Then run: while true; do wget -q -O- http://frontend-service.microservices-platform.svc.cluster.local; done
   ```

3. Watch HPA in action:
   ```bash
   kubectl get hpa -n microservices-platform --watch
   ```

## Notes

- Frontend scales based on CPU (70%) and memory (80%) usage
- API service scales more conservatively (75% CPU)  
- Worker nodes can scale from 1 to 8 instances
- Using simple LoadBalancer service (not ALB) to keep it basic

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
