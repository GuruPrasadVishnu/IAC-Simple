# Simple EC2 instance for testing - now in private subnet
# TODO: add more instances later if needed

# Application Load Balancer for public access
resource "aws_lb" "web_alb" {
  name               = "simple-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.foundation.outputs.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "simple-web-alb"
  }
}

# Security group for ALB (public-facing)
resource "aws_security_group" "alb_sg" {
  name        = "simple-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.foundation.outputs.vpc_id

  # HTTP access from internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "simple-alb-sg"
  }
}

# Target group for EC2 instances
resource "aws_lb_target_group" "web_tg" {
  name     = "simple-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.foundation.outputs.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "simple-web-tg"
  }
}

# ALB listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Security group for EC2 instances (private)
resource "aws_security_group" "web_sg" {
  name        = "simple-web-sg"
  description = "Security group for web servers in private subnet"
  vpc_id      = data.terraform_remote_state.foundation.outputs.vpc_id

  # HTTP access from ALB only
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # SSH access from bastion or VPN (for troubleshooting)
  # TODO: Replace with specific CIDR or security group
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # VPC CIDR only
  }

  # All outbound (for updates via NAT Gateway)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "simple-web-sg"
  }
}

# Simple web server instance in private subnet
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 (hardcoded for simplicity)
  instance_type = var.instance_type
  
  # Deploy in private subnet - no direct public IP
  subnet_id                   = data.terraform_remote_state.foundation.outputs.private_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = false  # Private instance

  # Enhanced web server setup
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Create a simple webpage with instance info
    cat > /var/www/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html>
    <head>
        <title>Guru's Web Server</title>
    </head>
    <body>
        <div class="container">
            <h1> Private Web Server</h1>
            <p><strong>Status:</strong> Running in private subnet</p>
            <p><strong>Access:</strong> Via Application Load Balancer</p>
            <p><strong>Security:</strong> No direct internet access</p>
        </div>
    </body>
    </html>
HTML
  EOF

  tags = {
    Name = "simple-web-server-private"
  }
}

# Attach EC2 instance to target group
resource "aws_lb_target_group_attachment" "web_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}
