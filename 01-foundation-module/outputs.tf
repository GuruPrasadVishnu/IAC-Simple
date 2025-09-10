# Outputs from the VPC module
output "vpc_id" {
  description = "VPC ID from module"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs from module"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs from module"
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "default_security_group_id" {
  description = "Default security group ID"
  value       = module.vpc.default_security_group_id
}

# Additional useful outputs from the module
output "availability_zones" {
  description = "Availability zones used"
  value       = module.vpc.azs
}

output "public_route_table_ids" {
  description = "Public route table IDs"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = module.vpc.private_route_table_ids
}
