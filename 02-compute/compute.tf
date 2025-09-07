# IAM role for EC2 to use Session Manager
resource "aws_iam_role" "ec2_role" {
    name = "${local.project_name}-ec2-session-manager-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name = "${local.project_name}-ec2-role"
    }
}

# Attach the Session Manager policy
resource "aws_iam_role_policy_attachment" "session_manager" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${local.project_name}-ec2-session-manager-profile"
    role = aws_iam_role.ec2_role.name
}

# EC2 Instance
resource "aws_instance" "web" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = local.private_subnet_ids[0]
    vpc_security_group_ids = [aws_security_group.ec2.id]
    iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

    user_data = <<-EOF
                #!/bin/bash
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello, World from ${local.project_name}'s EC2 instance!" > /var/www/html/index.html
                EOF

    tags = {
        Name = "${local.project_name}-ec2"
    }
}
