resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.prefix}-redis"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  security_group_ids   = [var.redis_security_group_id]
  subnet_group_name    = var.redis_subnet_group_name
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_cluster_id" {
  value = aws_elasticache_cluster.redis.cluster_id
}
