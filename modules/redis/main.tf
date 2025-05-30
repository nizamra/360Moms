resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "${var.name_prefix}-redis"
  node_type          = var.redis_node_type
  num_cache_nodes    = var.num_cache_nodes
  subnet_group_name  = var.redis_subnet_group_name
  security_group_ids = [var.redis_security_group_id]
  engine             = "redis"

  tags = {
    Name = "${var.name_prefix}-redis"
  }
}
