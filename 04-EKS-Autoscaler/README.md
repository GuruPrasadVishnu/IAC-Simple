# EKS Autoscaler - The Cool Stuff!

This is where Kubernetes shows off. Deploy apps that automatically scale up when busy and scale down when quiet. 

## What it does

- Deploys a simple demo website on Kubernetes
- Sets up Horizontal Pod Autoscaler (HPA) - pods scale 2 to 10 based on CPU
- Installs metrics server (required for autoscaling to work)
- Creates a public LoadBalancer so you can access it
- Very low CPU thresholds (20%) so you can see scaling in action quickly

## Prerequisites

- `01-foundation` deployed
- `03-EKS` deployed and kubectl working
- About 5 minutes of patience

## Deploy

```bash
terraform init
terraform plan  
terraform apply
```

## Test the autoscaling

1. **Get the website URL:**
   ```bash
   kubectl get svc -n microservices-platform
   # Look for the EXTERNAL-IP of the frontend service
   ```

2. **Check current pod count:**
   ```bash
   kubectl get pods -n microservices-platform
   kubectl get hpa -n microservices-platform
   ```

3. **Generate some load:**
   ```bash
   # Replace with your actual LoadBalancer URL
   for i in {1..100}; do curl -s http://your-loadbalancer-url > /dev/null & done
   ```

4. **Watch the magic happen:**
   ```bash
   # Watch pods scale up
   kubectl get pods -n microservices-platform --watch
   
   # In another terminal, watch HPA
   kubectl get hpa -n microservices-platform --watch
   ```

You should see CPU go up and pods scale from 2 to 10!

## What you learn

- How Kubernetes autoscaling works
- Why you need a metrics server
- How to set sensible CPU/memory thresholds
- That autoscaling takes 2-3 minutes to kick in (not instant)

## Clean up

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

