# ALB Security Group
resource "aws_security_group" "alb" {
    name_prefix = "${local.project_name}-alb-"
    vpc_id      = local.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.project_name}-sg-alb"
    }
}

# EC2 Security Group
resource "aws_security_group" "ec2" {
    name_prefix = "${local.project_name}-ec2-"
    vpc_id      = local.vpc_id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.project_name}-sg-ec2"
    }
}
