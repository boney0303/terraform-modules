locals {
  curr_tags = {
    State = "Current"
    DRCopyRDS = var.dr_region
    Name = var.stack_name
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
    cluster_identifier_prefix = "${var.stack_name}-cluster-"
    engine = var.db_engine
    engine_version = var.db_engine_ver
    port = var.db_port
    availability_zones = var.rds_availability_zones
    db_subnet_group_name = var.db_subnet_grp_name
    vpc_security_group_ids = var.db_security_grp_id
    backup_retention_period = var.backup_retention_period
    final_snapshot_identifier = var.final_snap_id
    storage_encrypted = true
    deletion_protection = var.deletion_protection
    master_username = var.rds_master_username
    master_password = var.rds_master_password
    iam_database_authentication_enabled = var.iam_database_authentication_enabled
    apply_immediately = var.apply_immidiate
    tags = merge(local.curr_tags, var.custom_tags )
    lifecycle {
      ignore_changes = ["cluster_identifier_prefix"]
    }
}

resource "aws_rds_cluster_instance" "aurora_db_instance" {
  count = var.db_instance_count
  identifier_prefix = "${var.stack_name}-db-"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class = var.rds_instance_class
  db_subnet_group_name = var.db_subnet_grp_name
  engine = var.db_engine
  publicly_accessible = var.publically_accessible
  apply_immediately = var.apply_immidiate
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  availability_zone = var.instance_availability_zone
  performance_insights_enabled = var.enable_performance_insights
  tags = merge(local.curr_tags, var.custom_tags )
  lifecycle {
    ignore_changes = ["identifier_prefix"]
  }
}
