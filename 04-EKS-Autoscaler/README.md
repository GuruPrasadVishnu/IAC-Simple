# EKS Autoscaler - Simplified Demo

Clean demonstration of Kubernetes horizontal pod autoscaling without complex dependencies.

## Components Deployed

- **Frontend Application**: Simple nginx service with HPA enabled
- **Simulated Database**: Mock service for demonstration purposes
- **Horizontal Pod Autoscaler**: Automatically scales frontend based on CPU usage
- **Load Tester**: Generates traffic to demonstrate autoscaling
- **LoadBalancer Service**: External access to the application

## Architecture

- **Frontend**: Scales automatically from 1-10 pods based on CPU usage (50% target)
- **Demo Focus**: Clean, simple autoscaling demonstration
- **No Complex Dependencies**: Self-contained module for easy demo

## Prerequisites

- 01-foundation module deployed
- 03-EKS cluster deployed and kubectl configured
- **Metrics Server**: Install using kubectl (post-deployment):

  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  ```

## Quick Demo

1. **Deploy the module**:
   ```bash
   terraform init
   terraform plan  
   terraform apply
   ```

2. **Test autoscaling**:
   ```bash
   # Watch the HPA in action
   kubectl get hpa -n guru-microservices-platform --watch
   
   # Monitor pod scaling
   kubectl get pods -n guru-microservices-platform --watch
   ```

3. **Generate load** (triggers autoscaling):
   ```bash
   # Use the included load tester
   kubectl exec -it deploy/load-tester -n guru-microservices-platform -- sh
   # Inside the pod: while true; do wget -q -O- http://frontend-service/; done
   ```

## Key Features

- **Simple Setup**: No complex database dependencies
- **Clean Demo**: Focus purely on autoscaling behavior
- **Professional**: Industry-standard HPA configuration
- **Observable**: Easy to monitor and demonstrate scaling

## Monitoring

```bash
# Check frontend pods (should scale 1-10 based on load)
kubectl get pods -l app=frontend -n guru-microservices-platform

# View HPA status and scaling decisions
kubectl describe hpa frontend-hpa -n guru-microservices-platform

## Cleanup

```bash
terraform destroy
```

Perfect for demonstrating modern Kubernetes autoscaling concepts in a clean, professional manner!

