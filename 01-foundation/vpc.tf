# VPC setup
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "${var.project_name}-vpc"
    }   
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Public subnets for ALB
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidrs[count.index]
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet-${count.index + 1}"
        Type = "public"
    }
}

# Private subnets for EKS nodes
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "${var.project_name}-private-subnet-${count.index + 1}"
        Type = "private"
    }
}

# Internet gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main-igw"
    }
}

# NAT gateway EIP
resource "aws_eip" "nat" {
    domain = "vpc"  # updated syntax
  
    tags = {
        Name = "nat-eip"
    }
}

# NAT gateway for private subnets
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public[0].id  # put in first public subnet

    tags = {
        Name = "main-nat"
    }

    depends_on = [aws_internet_gateway.main]
}

# Public route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "public-rt"
    }
}

# Private route table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }

    tags = {
        Name = "private-rt"
    }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
    
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private" {
    count = length(aws_subnet.private)
    
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}
