# Network Module Outputs
# This file defines all output values that are exported from the network module

#----------------------VPC Outputs----------------------#
# The unique identifier of the created VPC
output "vpc_id" {
  value       = aws_vpc.private_cloud.id
  description = "The ID of the VPC"
}

#----------------------Subnet Outputs----------------------#
# List of public subnet IDs for resources that need direct internet access
output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

# List of private subnet IDs for resources that need enhanced security
output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}

#----------------------Security Group Outputs----------------------#
# Security group ID for EC2 instances
output "security_group_id" {
  value       = aws_security_group.ec2.id
  description = "The ID of the EC2 security group"
}

# Security group ID for RDS instances
output "rds_security_group_id" {
  value       = aws_security_group.rds.id
  description = "The ID of the RDS security group" # Controls database access
}

# Security group ID for Redis clusters
output "redis_security_group_id" {
  value       = aws_security_group.redis.id
  description = "The ID of the Redis security group" # Controls cache access
}

#----------------------Subnet Group Outputs----------------------#
# Name of the RDS subnet group for database deployment
output "rds_subnet_group_name" {
  value       = aws_db_subnet_group.rds.name
  description = "The name of the RDS subnet group"
}

# Name of the Redis subnet group for cache deployment
output "redis_subnet_group_name" {
  value       = aws_elasticache_subnet_group.redis.name
  description = "The name of the Redis subnet group"
}
