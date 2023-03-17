variable "stack_name" {}
variable "env" {
  default = "stage"
}
variable "rds_instance_class" {}
variable "db_subnet_grp_name" {}
variable "db_engine" {}
variable "db_engine_ver" {}
variable "rds_availability_zones" {
  type = list(string)
}
variable "db_security_grp_id" {
  type = list(string)
}
variable "db_port" {}
variable "final_snap_id" {}
variable "publically_accessible" {}
variable "apply_immidiate" {}
variable "db_instance_count" {}
variable "auto_minor_version_upgrade" {}
variable "instance_availability_zone" {
  default = ""
}
variable "iam_database_authentication_enabled" {
  default = "true"
}
variable "backup_retention_period" {}
variable "rds_master_username" {}
variable "rds_master_password" {}
variable "dr_region" {}
variable "custom_tags" {
  default = {}
  type = map
}
variable "deletion_protection" {
  default = "true"
}
variable "enable_performance_insights" {}
