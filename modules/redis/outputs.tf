# Redis Module Outputs
# This file defines all output values that are exported from the Redis module

#----------------------Cluster Identifiers----------------------#
# Unique identifier of the Redis cluster
output "redis_id" {
  value       = aws_elasticache_cluster.redis.id
  description = "The unique identifier of the Redis cluster" # Used for referencing the cluster
}

#----------------------Connection Information----------------------#
# Primary endpoint for connecting to Redis
output "redis_endpoint" {
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
  description = "Redis cluster endpoint address" # Used for application configuration
}
