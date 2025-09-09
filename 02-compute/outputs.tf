# Enhanced outputs for private subnet setup

output "web_instance_private_ip" {
  description = "Private IP of web server"
  value       = aws_instance.web.private_ip
}

output "web_instance_id" {
  description = "Instance ID"
  value       = aws_instance.web.id
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer - use this to access the application"
  value       = aws_lb.web_alb.dns_name
}

output "load_balancer_url" {
  description = "Full URL to access the application"
  value       = "http://${aws_lb.web_alb.dns_name}"
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web_tg.arn
}
