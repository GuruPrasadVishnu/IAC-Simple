# Infrastructure as Code

This repository contains Terraform configurations for deploying AWS infrastructure in a layered approach.

## Project Structure

```text
├── 01-foundation/     # VPC, subnets, networking infrastructure
├── 02-compute/        # EC2 instances, load balancers, security groups
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

## Features

- **Foundation Layer**: Creates VPC, public/private subnets, internet gateway, NAT gateway
- **Compute Layer**: Deploys EC2 instances, application load balancer, security groups
- **Remote State**: Uses S3 backend with DynamoDB locking for state management
- **Layer Dependencies**: Compute layer reads foundation outputs via remote state

## Clean Up

To destroy resources (reverse order):

```bash
# Destroy compute layer first
cd 02-compute
terraform destroy

# Then destroy foundation
cd 01-foundation
terraform destroy
```
