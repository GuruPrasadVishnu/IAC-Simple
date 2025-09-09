# Foundation - Network Infrastructure

This module creates the base AWS networking infrastructure required for all other modules.

## Resources Created

- VPC with DNS support and hostnames enabled
- Public subnets for load balancers and NAT gateway
- Private subnets for secure server deployment
- Internet Gateway for public internet access
- NAT Gateway for private subnet internet access
- Route tables with appropriate routing rules

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

This module provides outputs consumed by other modules:
- VPC ID
- Public subnet IDs
- Private subnet IDs

## Validation

Verify in AWS Console:
- VPC created with correct CIDR block
- Subnets created in multiple availability zones
- NAT Gateway deployed (note: this incurs costs)
- Route tables configured properly

## Clean Up

```bash
terraform destroy
```

Note: Destroy dependent modules first before destroying this foundation.
