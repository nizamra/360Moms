output "vpc_id" {
  value       = aws_vpc.private_cloud.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}

output "security_group_id" {
  value       = aws_security_group.ec2.id
  description = "The ID of the EC2 security group"
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis.id
}

output "rds_subnet_group_name" {
  value       = aws_db_subnet_group.rds.name
  description = "The name of the RDS subnet group"
}

output "redis_subnet_group_name" {
  value       = aws_elasticache_subnet_group.redis.name
  description = "The name of the Redis subnet group"
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn  
}

output "alb_arn" {
  value = aws_lb.app_lb.arn
}

