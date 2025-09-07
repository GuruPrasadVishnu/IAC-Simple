output "alb_dns_name" {
    description = "DNS name of the load balancer"
    value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web.arn
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "website_url" {
  description = "URL of the website"
  value       = "http://${aws_lb.main.dns_name}"
}
