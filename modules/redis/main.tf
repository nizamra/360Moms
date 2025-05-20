resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.name_prefix}-redis"
  description          = "redis replication group for ${var.name_prefix} environment"
  node_type            = var.redis_node_type
  subnet_group_name    = var.redis_subnet_group_name
  security_group_ids   = [var.redis_security_group_id]
  engine               = "redis"
  num_cache_clusters   = var.redis_cache_clusters

  tags = {
    Name = "${var.name_prefix}-redis"
  }
}
