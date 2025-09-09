# Foundation - Network Setup

This is where it all starts. Sets up the basic AWS networking that everything else depends on.

## What it creates

- VPC (our own private cloud space)
- Public subnets (for load balancers and stuff that needs internet)
- Private subnets (for secure servers that shouldn't be directly accessible)
- Internet Gateway (how we get to the internet)
- NAT Gateway (how private servers get internet access safely)
- Route tables (traffic rules)

## Deploy

```bash
terraform init
terraform plan
terraform apply
```

## What you get

After running this, you'll have a solid network foundation that follows AWS best practices. Private subnets for security, public subnets for load balancers, and a NAT gateway so your private servers can still download updates.

## Validation

Check the AWS console - you should see:
- 1 VPC created
- 2 public subnets + 2 private subnets
- 1 NAT Gateway (costs money, just FYI)
- Route tables properly configured

## Clean up

```bash
terraform destroy
```

Note: This will break everything else that depends on it, so destroy other modules first.
