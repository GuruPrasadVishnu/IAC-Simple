# Compute - Simple Web Server

A basic web server setup that's actually secure. EC2 instance in a private subnet with a load balancer in front.

## What it does

- Creates an Application Load Balancer (ALB) in public subnets
- Launches an EC2 instance in a private subnet (no direct internet access)
- Sets up security groups (firewall rules)
- Serves a simple webpage about being in a private subnet

## Why private subnet?

Security! The web server can't be directly attacked from the internet. All traffic goes through the load balancer first.

## Deploy

Make sure you've deployed `01-foundation` first!

```bash
terraform init
terraform plan
terraform apply
```

## Access your site

After deployment, you'll get a load balancer URL:

```bash
terraform output load_balancer_url
```

Visit that URL in your browser. Should see a simple page saying it's running in a private subnet.

## Validation

- Test the URL - webpage should load
- Check AWS console - EC2 instance should have NO public IP
- Load balancer should be in public subnets
- Try curling the URL from command line

## Architecture

```
Internet → ALB (public) → EC2 (private) → NAT Gateway → Internet (for updates)
```

## Clean up

```bash
terraform destroy
```
