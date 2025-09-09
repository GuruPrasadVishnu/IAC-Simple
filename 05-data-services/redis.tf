# Simple Redis Cache
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "simple-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  
  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis_sg.id]
  
  tags = {
    Name = "simple-redis"
  }
}

# Put Redis in private subnets
resource "aws_elasticache_subnet_group" "redis" {
  name       = "demo-redis-subnets"
  subnet_ids = data.terraform_remote_state.foundation.outputs.private_subnet_ids
}

# Allow access from VPC
resource "aws_security_group" "redis_sg" {
  name   = "simple-redis-sg"
  vpc_id = data.terraform_remote_state.foundation.outputs.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
