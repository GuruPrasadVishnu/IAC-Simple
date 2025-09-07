# Application Load Balancer
resource "aws_lb" "main" {
    name               = "${local.project_name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = local.public_subnet_ids

    enable_deletion_protection = false

    tags = {
        Name = "${local.project_name}-alb"
    }
}

# Target Group
resource "aws_lb_target_group" "web" {
    name     = "${local.project_name}-alb-target-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = local.vpc_id

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
        port                = "traffic-port"
        protocol            = "HTTP"               
    }
    
    tags = {
        Name = "${local.project_name}-alb-target-group"
    }
}

# ALB Listener
resource "aws_lb_listener" "web" {
    load_balancer_arn = aws_lb.main.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type = "forward"
        forward {
            target_group {
                arn = aws_lb_target_group.web.arn
            }
        }
    }
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "web" {
    target_group_arn = aws_lb_target_group.web.arn
    target_id        = aws_instance.web.id
    port             = 80
}
