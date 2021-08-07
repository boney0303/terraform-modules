data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20191116.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["137112412989"] # Canonical
}

resource "aws_launch_configuration" "demo_project_lc" {
  name_prefix = var.stack_name
  image_id = data.aws_ami.amazon.id
  instance_type = var.instance_type
  iam_instance_profile = var.instance_profile
  key_name = var.key_pair
  security_groups = var.security_groups
  associate_public_ip_address = var.associate_public_ip_address
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo_project_asg" {
  name_prefix = var.stack_name
  launch_configuration = var.create_lc ? element(concat(aws_launch_configuration.demo_project_lc.*.name, [""]), 0) : var.launch_configuration
  vpc_zone_identifier  = var.vpc_zone_identifier
  desired_capacity = var.desired_capacity
  max_size = var.asg_max
  min_size = var.asg_min
  default_cooldown = var.default_cooldown
  health_check_grace_period = var.health_check_grace_period
  health_check_type = var.health_check_type
  enabled_metrics = var.enabled_metrics
  metrics_granularity = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  initial_lifecycle_hook {
      name = "${var.stack_name}-launch"
      heartbeat_timeout = 30
      default_result = "CONTINUE"
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_target_arn = var.AdAutoScalingTopic
      role_arn = var.AsgLifecycleRole
  }
  initial_lifecycle_hook {
      name = "${var.stack_name}-terminate"
      heartbeat_timeout = 30
      default_result = "CONTINUE"
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_target_arn = var.AdAutoScalingTopic
      role_arn = var.AsgLifecycleRole
  }

  tags = [
    {
      key                 = "Environment"
      value               = "test"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "demo-project"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }  
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = var.create_asg ? element(concat(aws_autoscaling_group.demo_project_asg.*.name, [""]), 0) : var.asg_name
  alb_target_group_arn   = var.target_group_arn
}
