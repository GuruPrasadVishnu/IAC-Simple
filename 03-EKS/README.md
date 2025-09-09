# EKS - Kubernetes Cluster

Sets up a production-ready Kubernetes cluster on AWS. This is where the magic happens if you want to run containers.

## What it creates

- EKS cluster (managed Kubernetes control plane)
- Worker nodes (EC2 instances that run your containers)
- All the IAM roles and policies needed
- Security groups for cluster communication
- Node groups in private subnets (secure!)

## Prerequisites

- `01-foundation` must be deployed first
- AWS credentials configured
- kubectl installed on your machine

## Deploy

```bash
terraform init
terraform plan
terraform apply
```

This takes about 10-15 minutes. EKS clusters are slow to create, grab a coffee.

## Connect kubectl

After deployment:

```bash
aws eks update-kubeconfig --region us-east-1 --name simple-eks-cluster
kubectl get nodes
```

You should see your worker nodes listed.

## What you get

A fully functional Kubernetes cluster that can run containers. The worker nodes are in private subnets for security, but the cluster can still pull images from the internet via NAT gateway.

## Validation

```bash
# Check cluster status
kubectl get nodes

# Check if system pods are running
kubectl get pods -A

# Deploy a test pod
kubectl run test-pod --image=nginx --port=80
kubectl get pods
```

## Clean up

```bash
terraform destroy
```

Warning: This also takes 10-15 minutes to destroy!
- **Security Groups**: EKS-specific security rules

### IAM Resources
- **Cluster Service Role**: For EKS control plane operations
- **Node Group Role**: For worker node EC2 instances
- **Minimal Permissions**: Following principle of least privilege

### Key Features
- **Private Networking**: Nodes in private subnets, no direct internet access
- **Cost Optimized**: t3.medium instances, shared NAT Gateway
- **Simplified Setup**: No complex add-ons, focused on core functionality
- **CloudWatch Integration**: Essential logging enabled

## Getting Started

### Prerequisites
- AWS CLI v2.x+ configured with appropriate permissions
- Terraform >= 1.0
- kubectl >= 1.27
- VPC layer must be deployed first

### Deployment Steps

1. **Verify VPC layer is deployed**:
   ```bash
   cd ../01-VPC
   terraform output
   ```

2. **Deploy EKS cluster**:
   ```bash
   cd ../02-EKS
   terraform init
   terraform plan
   terraform apply
   ```
   *Note: EKS cluster creation takes about 10-15 minutes*

3. **Configure kubectl**:
   ```bash
   # Use the exact command from terraform output
   aws eks update-kubeconfig --region us-east-1 --name guru-platform-eks
   
   # Verify connection
   kubectl get nodes
   kubectl cluster-info
   ```

4. **Verify everything works**:
   ```bash
   # Check node status
   kubectl get nodes -o wide
   
   # Check system pods
   kubectl get pods -n kube-system
   
   # Create a simple test
   kubectl create deployment test-nginx --image=nginx
   kubectl expose deployment test-nginx --port=80 --type=LoadBalancer
   ```

## Configuration

### Variables
- `region`: AWS region (default: us-east-1)
- `environment`: Environment name (default: dev)
- `kubernetes_version`: EKS version (default: 1.33)
- `desired_nodes`: Desired number of worker nodes (default: 2)
- `min_nodes`: Minimum number of worker nodes (default: 1)
- `max_nodes`: Maximum number of worker nodes (default: 4)

### Key Outputs
- `cluster_name`: Name of the EKS cluster
- `cluster_endpoint`: EKS cluster API endpoint
- `cluster_version`: Kubernetes version
- `kubeconfig_command`: Ready-to-use kubectl setup command
- `node_group_arn`: ARN of the node group
- VPC outputs (passed through from networking layer)

## File Structure

```
02-EKS/
├── main.tf              # Common tags and backend configuration
├── vpc-data.tf          # Remote state data source for VPC
├── iam.tf               # IAM roles for EKS cluster and nodes
├── eks-cluster.tf       # EKS cluster configuration
├── eks-nodes.tf         # Managed node group configuration
├── providers.tf         # AWS and Kubernetes provider setup
├── variables.tf         # Input variables
├── outputs.tf           # Outputs (EKS + VPC pass-through)
├── init.tf              # Provider requirements
└── README.md            # This file
```

## Network Design

The EKS cluster leverages the shared VPC infrastructure:

### VPC Layout (from 01-VPC layer)
- **CIDR**: 10.20.0.0/16
- **Private subnets**: 10.20.1.0/24, 10.20.2.0/24 (EKS nodes)
- **Public subnets**: 10.20.101.0/24, 10.20.102.0/24 (load balancers)
- **Single NAT Gateway**: Cost-optimized shared networking

### EKS Configuration
- **Cluster**: guru-ms-platform-eks
- **Version**: Kubernetes 1.33
- **Node Group**: 2-4 t3.medium instances (ON_DEMAND)
- **Networking**: Private subnets only for nodes, public for LoadBalancers

## Security Considerations

- **Private Node Placement**: Worker nodes in private subnets only
- **API Endpoint**: Public but can be restricted to specific IPs
- **No Direct Internet**: Nodes use NAT Gateway for outbound traffic
- **Least Privilege IAM**: Minimal required permissions
- **Security Groups**: EKS-specific rules following AWS best practices

## Cost Optimization

This layer's costs (VPC costs are in the networking layer):
- **EKS Control Plane**: ~$73/month (fixed AWS cost)
- **2x t3.medium nodes**: ~$60/month (variable based on usage)
- **EBS volumes**: ~$10/month (20GB per node)
- **Layer Total**: ~$143/month

*Note: VPC/NAT Gateway costs (~$45/month) are in the 01-VPC layer and shared across services*

## Monitoring and Logging

- **Control Plane Logs**: API, audit, and authenticator logs to CloudWatch
- **Node Logs**: Worker node logs available in CloudWatch
- **Metrics**: Basic CloudWatch metrics enabled
- **Ready for Add-ons**: Can add Metrics Server, Prometheus, etc.

## Troubleshooting

### Common Issues
1. **VPC not found**: Ensure `01-VPC` is deployed and state is accessible
2. **Remote state access denied**: Check S3 bucket permissions
3. **Subnet not available**: Verify VPC outputs match expected format

### Validation Commands
```bash
# Check remote state access
terraform console
> data.terraform_remote_state.vpc.outputs

# Verify VPC dependency
terraform plan | grep "data.terraform_remote_state.vpc"

# Check state file location
aws s3 ls s3://guru-terraform-state-bucket/03-EKS/
```

### Debug Remote State
```bash
# Check VPC state directly
aws s3 cp s3://guru-terraform-state-bucket/terraform.tfstate - | jq '.outputs'

# Show current state references
terraform show -json | jq '.values.root_module.resources[] | select(.type == "terraform_remote_state")'
```

## Next Steps

Once the basic cluster is running, consider adding:

### Immediate Add-ons
- **Metrics Server**: For `kubectl top` commands and HPA
- **AWS Load Balancer Controller**: For advanced ingress management
- **Cluster Autoscaler**: For automatic node scaling based on demand

### Advanced Features
- **Monitoring Stack**: Prometheus, Grafana, CloudWatch Container Insights
- **Security**: Pod Security Standards, Network Policies, IRSA
- **GitOps**: ArgoCD or Flux for application deployment
- **Service Mesh**: Istio or App Mesh for advanced traffic management

### Additional Services
Since the VPC is shared, you can add:
- **Database Layer** (`03-RDS`): Use private subnets
- **Application Layer** (`04-Apps`): Reference EKS outputs
- **Monitoring Layer** (`05-Monitoring`): Deploy observability stack

## Clean Up

To destroy this layer without affecting the VPC:

```bash
terraform destroy
```

*Note: This only destroys the EKS cluster. The VPC remains for other services.*

To destroy everything (reverse dependency order):
```bash
# 1. Destroy EKS first
cd 02-EKS && terraform destroy

# 2. Destroy VPC second  
cd ../01-VPC && terraform destroy

# 3. Destroy remote state last (optional)
cd "../00-S3 creation" && terraform destroy
```

## Benefits of This Modular Approach

- **Resource Reuse**: VPC can support multiple services
- **Independent Lifecycles**: Update EKS without touching networking
- **Team Collaboration**: Different teams can own different layers
- **Cost Efficiency**: Shared infrastructure reduces duplicate resources
- **Simplified Troubleshooting**: Clear separation of concerns
- **Scalable Architecture**: Easy to add new services using the same pattern
