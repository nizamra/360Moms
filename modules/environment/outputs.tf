output "app_instance_public_ip" {
  value = aws_instance.app.public_ip
}

output "ec2_instance_id" {
  value       = aws_instance.app.id
  description = "The ID of the EC2 instance"
}

output "rds_identifier" {
  value       = aws_db_instance.db_instance.id
  description = "The identifier of the RDS instance"
}

output "redis_cluster_id" {
  value       = aws_elasticache_replication_group.redis.id
  description = "The ID of the Redis cluster"
}
