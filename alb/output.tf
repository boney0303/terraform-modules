output "alb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = try(aws_lb.demo_webapp_alb[0].id, "")
}
output "alb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = try(aws_lb.demo_webapp_alb[0].arn, "")
}
output "alb_tg_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.demo_webapp_alb_tg[*].arn
}

output "alb_tg_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group"
  value       = aws_lb_target_group.demo_webapp_alb_tg[*].name
}

