variable "region" {}
variable "stack_name" {}
# ASG Vars
variable "asg_desired_capacity" {}
variable "wait_for_capacity_timeout" {}
variable "asg_min" {}
variable "asg_max" {}
variable "asg_health_check_type" {
  default = "EC2"
}
variable "vpc_zone_identifier" {
  type = list(string)
}
variable "wait_for_elb_cap" {}

variable "webapp_lt" {}

variable "alb_tg_arns" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  type        = list(string)
}