output "lt_name" {
  value = aws_launch_template.webapp_ec2_lt.name
}
output "ami_id" {
  value = var.image_id
}

output "lt_id" {
  value = aws_launch_template.webapp_ec2_lt.id
}