resource "aws_autoscaling_group" "webapp_asg" {
  name_prefix = "${var.stack_name}-asg-"
  wait_for_elb_capacity = var.wait_for_elb_cap
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  desired_capacity = var.asg_desired_capacity
  max_size = var.asg_max
  min_size = var.asg_min
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns = var.alb_tg_arns
  metrics_granularity = "1Minute"
  enabled_metrics = ["GroupInServiceInstances"]
  health_check_type = var.asg_health_check_type

  launch_template {
    id      = var.webapp_lt
    version = "$Latest"
  }

  initial_lifecycle_hook {
      name = "${var.stack_name}-launch"
      heartbeat_timeout = 30
      default_result = "CONTINUE"
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }
  initial_lifecycle_hook {
      name = "${var.stack_name}-terminate"
      heartbeat_timeout = 30
      default_result = "CONTINUE"
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["name_prefix"]
  }
}
