# EKS Autoscaler - Horizontal Pod Autoscaling

Demonstrates Kubernetes horizontal pod autoscaling with a sample web application.

## Components Deployed

- Sample web application on Kubernetes
- Horizontal Pod Autoscaler configured for CPU-based scaling
- Metrics server for resource monitoring
- LoadBalancer service for external access
- Low CPU thresholds for demonstration purposes

## Prerequisites

- 01-foundation module deployed
- 03-EKS cluster deployed and kubectl configured
- Sufficient time for deployment (approximately 5 minutes)

## Deployment

```bash
terraform init
terraform plan  
terraform apply
```

## Testing Autoscaling

1. **Get application URL:**
   ```bash
   kubectl get svc -n microservices-platform
   # Note the EXTERNAL-IP of frontend service
   ```

2. **Check current pod count:**
   ```bash
   kubectl get pods -n microservices-platform
   kubectl get hpa -n microservices-platform
   ```

3. **Generate load for testing:**
   ```bash
   # Replace URL with your LoadBalancer external IP
   for i in {1..100}; do curl -s http://your-loadbalancer-url > /dev/null & done
   ```

4. **Monitor scaling behavior:**
   ```bash
   # Watch pod scaling
   kubectl get pods -n microservices-platform --watch
   
   # Monitor HPA metrics
   kubectl get hpa -n microservices-platform --watch
   ```

## Expected Behavior

- Initial deployment: 2 pods
- Under load: scales up to maximum 10 pods
- CPU threshold: 20% (configured low for quick demonstration)
- Scaling delay: 2-3 minutes for scale-up decisions

## Learning Objectives

- Understanding Kubernetes autoscaling mechanisms
- Importance of metrics server for HPA functionality
- CPU and memory threshold configuration
- Autoscaling timing and behavior patterns

## Clean Up

```bash
terraform destroy
```
kubectl get svc -n microservices-platform frontend-service
# Visit the EXTERNAL-IP in your browser
```

**4. Test autoscaling - generate load:**
```bash
kubectl exec -it deploy/load-tester -n microservices-platform -- sh

# Inside the pod, run this to create CPU load:
for i in $(seq 1 10); do (while true; do echo 'stress' | md5sum; done) & done
```

**5. Watch pods scale up (in another terminal):**
```bash
kubectl get pods -n microservices-platform -w
# You should see new pods being created
```

**6. Verify scaling worked:**
```bash
kubectl get hpa -n microservices-platform
# CPU should be high and REPLICAS should increase
```

