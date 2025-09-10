# Foundation with Terraform Module - Learning Demo

This directory demonstrates using **pre-built Terraform modules** instead of raw resources for creating AWS VPC infrastructure.

## 🔄 **Module vs Raw Resources Comparison**

| Aspect | **Raw Resources (01-foundation)** | **Module Approach (this directory)** |
|--------|-----------------------------------|--------------------------------------|
| **Lines of Code** | ~120 lines across multiple files | ~25 lines in main.tf |
| **Complexity** | Manual resource dependencies | Module handles dependencies |
| **Maintenance** | You maintain all resource configs | Module community maintains |
| **Features** | Only what you explicitly code | Rich feature set built-in |
| **Learning Curve** | Learn every AWS resource detail | Learn module interface |

## 🎯 **What the Module Gives You**

The `terraform-aws-modules/vpc/aws` module automatically creates:

- ✅ VPC with DNS settings
- ✅ Public & Private subnets across AZs
- ✅ Internet Gateway
- ✅ NAT Gateway(s) with Elastic IP
- ✅ Route tables and associations
- ✅ Default security group
- ✅ Proper tags and naming
- ✅ Best practices built-in

## 🚀 **Deploy and Compare**

```bash
# Initialize and deploy
terraform init
terraform plan
terraform apply

# Compare outputs with 01-foundation
terraform output

# See what the module created
terraform show
```

## 🎓 **Key Learning Points**

1. **Speed**: Module approach is much faster to write
2. **Features**: Module includes advanced features you might miss
3. **Best Practices**: Community-tested configurations
4. **Maintenance**: Module updates bring improvements
5. **Trade-off**: Less granular control vs convenience

## 🔍 **Module Configuration Highlights**

```terraform
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  # Core settings
  name = "guru-module-vpc"
  cidr = "10.1.0.0/16"
  
  # Automatic subnet creation
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.10.0/24", "10.1.11.0/24"]
  
  # Features enabled with one line
  enable_nat_gateway = true
  single_nat_gateway = true
}
```

## 🧹 **Cleanup**

```bash
terraform destroy
```

Perfect for understanding the power and convenience of Terraform modules!
