# Infrastructure as Code - Demo Project

Professional AWS infrastructure demonstrating modern cloud-native patterns with Terraform and Kubernetes.

## Project Structure

- **01-foundation/** - Network foundation: VPC, subnets, NAT gateway
- **02-compute/** - Web server with load balancer
- **03-EKS/** - Production-ready Kubernetes cluster
- **04-EKS-Autoscaler/** - Simplified HPA demonstration (no complex dependencies)
- **05-data-services/** - AWS managed services: PostgreSQL, Redis, Kafka

## Architecture Highlights

✅ **Professional Setup**: Production-ready patterns and best practices  
✅ **Clean Demos**: Simplified for clear demonstration without complexity  
✅ **Multi-Service**: Complete cloud-native stack with managed services  
✅ **Security**: VPC isolation, private subnets, proper IAM roles

## Deployment Order

Each module builds on the previous:

1. **01-foundation/** - Deploy VPC and networking
2. **03-EKS/** - Deploy Kubernetes cluster
3. **04-EKS-Autoscaler/** - Add autoscaling demo (optional)
4. **05-data-services/** - Add databases and messaging (optional)

## Prerequisites

- AWS CLI configured with credentials
- Terraform installed (1.0+)
- kubectl installed (for Kubernetes modules)

### S3 State Bucket Setup

Create bucket for Terraform state:

- Bucket name: `guru-terraform-state-bucket`
- Region: `us-east-1`
- Enable versioning
- Keep default security settings

## Quick Demo

```bash
# Configure AWS credentials
aws configure

# Deploy foundation
cd 01-foundation && terraform init && terraform apply

# Deploy EKS cluster  
cd ../03-EKS && terraform init && terraform apply

# Add autoscaling demo
cd ../04-EKS-Autoscaler && terraform init && terraform apply

# Add data services
cd ../05-data-services && terraform init && terraform apply
```

## Cleanup

Destroy in reverse order:

```bash
cd 05-data-services && terraform destroy
cd ../04-EKS-Autoscaler && terraform destroy  
cd ../03-EKS && terraform destroy
cd ../01-foundation && terraform destroy
```

Perfect for demonstrating modern AWS infrastructure and Kubernetes patterns!
cd 05-data-services && terraform destroy
cd ../04-EKS-Autoscaler && terraform destroy  
cd ../03-EKS && terraform destroy
cd ../01-foundation && terraform destroy
```
