variable "region" {}
variable "stack_name" {}
# Launch config Vars
variable "image_id" {}
variable "instance_type" {}
variable "ssh_key" {}
variable "ec2_security_grps" {
  type = list(string)
  default = []
}
variable "iam_instance_profile" {}
variable "tags" {
    type    = map
    default = {}
}