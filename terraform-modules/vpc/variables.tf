# Module Input Variables
# These define the interface for your module - what teams can customize

variable "name" {
  description = "Name prefix for all resources"
  type        = string
  
  validation {
    condition     = length(var.name) <= 20
    error_message = "Name must be 20 characters or less for AWS resource naming limits."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  
  validation {
    condition     = length(var.public_subnet_cidrs) >= 1 && length(var.public_subnet_cidrs) <= 4
    error_message = "Must provide between 1 and 4 public subnet CIDRs."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  
  validation {
    condition     = length(var.private_subnet_cidrs) >= 1 && length(var.private_subnet_cidrs) <= 4
    error_message = "Must provide between 1 and 4 private subnet CIDRs."
  }
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Optional: Allow teams to control NAT Gateway behavior
variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost-effective)"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

# Optional: Environment-specific settings
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
