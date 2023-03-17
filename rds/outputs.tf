output "rds_cluster_name" {
  value = aws_rds_cluster.aurora_cluster.id
}
output "rds_cluster_end_point" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}
output "rds_cluster_end_port" {
  value = aws_rds_cluster.aurora_cluster.port
}
output "rds_instance_id" {
  value = aws_rds_cluster_instance.aurora_db_instance[0].id
}
output "rds_instance_end_point" {
  value = aws_rds_cluster_instance.aurora_db_instance[0].endpoint
}
output "rds_instnace_end_port" {
  value = aws_rds_cluster_instance.aurora_db_instance[0].port
}