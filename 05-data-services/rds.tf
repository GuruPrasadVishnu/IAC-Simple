# Quick demo PostgreSQL Database
resource "aws_db_instance" "postgresql" {
  identifier     = "demo-postgres-db"
  engine         = "postgres"
  engine_version = "15.7"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_encrypted = false  # Simplified for demo
  
  db_name  = "demoapp"
  username = "demouser"
  password = "DemoPass123!"
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  skip_final_snapshot       = true
  deletion_protection       = false
  backup_retention_period   = 0  # No backups for demo
  maintenance_window        = "sun:03:00-sun:04:00"
  backup_window            = "04:00-05:00"
  
  tags = {
    Name        = "demo-postgres"
    Environment = "demo"
    Purpose     = "assessment"
  }
}

# Put database in private subnets
resource "aws_db_subnet_group" "main" {
  name       = "demo-db-subnets"
  subnet_ids = data.terraform_remote_state.foundation.outputs.private_subnet_ids
  
  tags = {
    Name = "demo-db-subnet-group"
  }
}

# Allow access from VPC
resource "aws_security_group" "rds_sg" {
  name   = "demo-rds-sg"
  vpc_id = data.terraform_remote_state.foundation.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-rds-sg"
  }
}

