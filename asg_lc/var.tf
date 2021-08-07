variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default = "us-east-1"
  type        = string
}

variable "stack_name" {
  description = "The name of the stack."
  default = "prod"
  type        = string
}

#### Launch configuration variables ####
variable "create_lc" {
  description = "Whether to create launch configuration"
  type        = bool
  default     = true
}
variable "instance_type" {
  description = "The type of EC2 Instnaces to run in the ASG (e.g. t2.micro)"
  default = "t2.micro"
  type        = string
}
variable "instance_profile" {
  description = "The instance profile arn (e.g. TF_InstanceProfile)"
  default = "EC2-Prod-Instance-Profile"
  type = string
}
variable "key_pair" {
  description = "the key_pair name (i.e us-east-1-2020-q1)"
  default = "us-east-1-2020-q1"
  type = string
}
variable "security_groups" {
  description = "the list of security group ids "
  default = [
   "sg-05f2aa200f490de11",
   "sg-0ed94c2dfa02f6493",
  ]
  type = list(string)
}
variable "associate_public_ip_address" {
  description = "the boolean value for associate_public_ip_address"
  default = true
  type = bool
}

#### ASG variable ####

variable "create_asg" {
  description = "Whether to create autoscaling group"
  type        = bool
  default     = true
}
variable "asg_name" {
  description = "Creates a unique name for autoscaling group beginning with the specified prefix"
  type        = string
  default     = ""
}
variable "launch_configuration" {
  description = "The name of the launch configuration to use (if it is created outside of this module)"
  type        = string
  default     = ""
}
variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
  default = 2
}
variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}
variable "target_group_arn" {
  description = "The  aws_alb_target_group ARN, for use with Application or Network Load Balancing."
  type        = string
  default     = ""
}
variable "asg_min" {
  description = "The minimum size of the auto scale group"
  type        = string
  default = 2
}
variable "asg_max" {
  description = "The maximum size of the auto scale group"
  type        = string
  default = 5
}
variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}
variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}
variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  type        = string
  default = "EC2"
}
variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}
variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  type        = string
  default     = "1Minute"
}
variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = "10m"
}
variable "AdAutoScalingTopic" {
  description = "The ARN of the notification target that Auto Scaling will use to notify you when an instance is in the transition state for the lifecycle hook" 
  type        = string
  default = "arn:aws:sns:us-east-1:036476392584:tf-sns-topic"
}
variable "AsgLifecycleRole" {
  description = "The ARN of the IAM role that allows the Auto Scaling group to publish to the specified notification target."
  type        = string
  default = "arn:aws:iam::036476392584:role/EC2-Prod-Instance-Profile"
}
