# Data Services - AWS Managed Services Demo

Complete demonstration of AWS managed data services integrated with EKS.

## Components Deployed

- **PostgreSQL RDS**: Demo database with simple credentials
- **Redis ElastiCache**: Single-node cache cluster  
- **Kafka MSK**: 2-broker messaging cluster
- **Kubernetes Integration**: Test pods and sample application
- **Security Groups**: Proper VPC isolation and access control

## Quick Start

```bash
# Deploy all data services
terraform init
terraform plan
terraform apply

# Test database connectivity
kubectl exec -it postgres-test -n database-test -- psql -h $PGHOST -U $PGUSER -d $PGDATABASE
```

## Architecture

- **RDS PostgreSQL**: Private subnets, demo database `demoapp`
- **ElastiCache Redis**: VPC-isolated cache for session storage
- **MSK Kafka**: Multi-AZ messaging for event streaming
- **EKS Integration**: Kubernetes pods can connect to all services

## Testing & Validation

### Database Connection Test

```bash
# Connect to PostgreSQL from test pod
kubectl exec -it postgres-test -n database-test -- psql -h $PGHOST -U $PGUSER -d $PGDATABASE

# Quick connection test
kubectl exec postgres-test -n database-test -- psql -h $PGHOST -U $PGUSER -d $PGDATABASE -c "SELECT 'Connected!' as status;"
```

### Application Integration

Sample deployment shows how applications connect:

```bash
# Check sample app with database environment variables
kubectl describe deployment sample-app -n database-test

# View all deployed resources
kubectl get all -n database-test
```

### Service Endpoints

```bash
# View all service endpoints
terraform output

# Check individual services
terraform output postgres_endpoint
terraform output redis_endpoint
```

## Key Features

- **Demo-Optimized**: Simplified credentials and configuration
- **Production-Pattern**: Shows real-world AWS managed services integration
- **Security**: VPC-private databases with proper security groups
- **Observable**: Easy to test and validate connections
## Prerequisites

- 01-foundation module deployed (VPC and networking)
- 03-EKS cluster deployed and running
- kubectl configured: `aws eks update-kubeconfig --region us-east-1 --name guru-eks-cluster`

## Service Information

- **PostgreSQL**: Stores application data with demo credentials
- **Redis**: Provides caching for session storage and performance
- **Kafka**: Handles event streaming and message queuing

## Cleanup

```bash
terraform destroy
```

Demonstrates comprehensive AWS managed services integration with Kubernetes!
