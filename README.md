# Infrastructure as Code Project

AWS infrastructure setup using Terraform. This project demonstrates different deployment patterns from basic EC2 to EKS with autoscaling.

## Project Structure

- **01-foundation/** - Network foundation: VPC, subnets, NAT gateway
- **02-compute/** - Web server with load balancer in private subnet
- **03-EKS/** - Kubernetes cluster setup
- **04-EKS-Autoscaler/** - EKS with horizontal pod autoscaling

## Deployment Order

Follow this sequence (each folder has detailed README):

1. `01-foundation/` - Deploy network infrastructure
2. `02-compute/` OR `03-EKS/` - Choose EC2 or Kubernetes path
3. `04-EKS-Autoscaler/` - Only after EKS deployment

## Prerequisites

- AWS CLI configured with credentials
- Terraform installed
- kubectl (for EKS modules)

## Quick Start

```bash
# Configure AWS credentials
aws configure

# In each directory:
terraform init
terraform plan
terraform apply
```
## Clean Up

Destroy resources in reverse order:

```bash
cd 04-EKS-Autoscaler && terraform destroy
cd ../03-EKS && terraform destroy  
cd ../02-compute && terraform destroy
cd ../01-foundation && terraform destroy
```
