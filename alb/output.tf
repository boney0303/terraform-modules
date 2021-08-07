output "demo_project_alb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = concat(aws_lb.demo_project_alb.*.id, [""])[0]
}
output "demo_project_alb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = concat(aws_lb.demo_project_alb.*.arn, [""])[0]
}
output "demo_project_alb_tg_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.demo_project_alb_tg.*.arn
}

