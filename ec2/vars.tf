variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default = "us-east-1"
  type        = string
}

variable "name" {
  description = "The name for the ec2 instance."
  default = "tf-host"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instnaces to run in the ASG (e.g. t2.micro)"
  default = "t2.micro"
  type        = string
}

variable "tf_role_arn" {
  description = "The instance profile arn (e.g. TF_InstanceProfile)"
  default = "arn:aws:iam::036476392584:role/EC2-Prod-Instance-Profile"
  type = string
}
