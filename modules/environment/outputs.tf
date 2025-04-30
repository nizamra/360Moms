# outputs.tf (updated)
output "launch_template_id" {
  value       = aws_launch_template.app.id
  description = "The ID of the Launch Template"
}

output "autoscaling_group_name" {
  value       = aws_autoscaling_group.app.name
  description = "The name of the Auto Scaling Group"
}

# Keep existing RDS/Redis outputs (unchanged)
output "rds_identifier" {
  value       = aws_db_instance.db_instance.id
  description = "The identifier of the RDS instance"
}

output "redis_cluster_id" {
  value       = aws_elasticache_replication_group.redis.id
  description = "The ID of the Redis cluster"
}