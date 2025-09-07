# Infrastructure as Code

This repository contains Terraform configurations for deploying AWS infrastructure in a layered approach.

## Project Structure

```text
├── 01-foundation/     # VPC, subnets, networking infrastructure
├── 02-compute/        # EC2 instances, load balancers, security groups
├── 03-EKS/           # EKS cluster and node groups
└── backup/           # Backup configurations
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version ~> 4.0)

## Deployment

### 1. Foundation Layer

Deploy the networking foundation first:

```bash
cd 01-foundation
terraform init
terraform plan
terraform apply
```

### 2. Compute Layer

Deploy the compute resources:

```bash
cd 02-compute
terraform init
terraform plan
terraform apply
```

### 3. EKS Layer

Deploy the Kubernetes cluster:

```bash
cd 03-EKS
terraform init
terraform plan
terraform apply
```

## Features

- **Foundation Layer**: Creates VPC, public/private subnets, internet gateway, NAT gateway
- **Compute Layer**: Deploys EC2 instances, application load balancer, security groups
- **EKS Layer**: Managed Kubernetes cluster with worker nodes and auto-scaling
- **Remote State**: Uses S3 backend with DynamoDB locking for state management
- **Layer Dependencies**: Each layer reads previous layer outputs via remote state

## Clean Up

To destroy resources (reverse order):

```bash
# Destroy EKS layer first
cd 03-EKS
terraform destroy

# Then destroy compute layer
cd 02-compute
terraform destroy

# Finally destroy foundation
cd 01-foundation
terraform destroy
```
