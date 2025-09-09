# Compute - Web Server Infrastructure

Secure web server deployment using EC2 instances in private subnets with Application Load Balancer for public access.

## Architecture

- Application Load Balancer in public subnets
- EC2 instance in private subnet (no public IP)
- Security groups for controlled access
- Simple web application serving static content

## Security Benefits

The web server cannot be directly accessed from internet. All traffic must go through the load balancer, providing additional security layer.

## Prerequisites

- 01-foundation module must be deployed first

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Access Application

After deployment, get the load balancer URL:

```bash
terraform output load_balancer_url
```

Open this URL in web browser to view the application.

## Validation Steps

- Verify webpage loads correctly
- Check EC2 instance has no public IP in AWS Console
- Confirm load balancer is in public subnets
- Test application accessibility from internet

## Architecture Flow

```
Internet → ALB (public subnets) → EC2 (private subnet) → NAT Gateway → Internet
```

## Clean Up

```bash
terraform destroy
```
