# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "${var.prefix}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.prefix}-redis-subnet-group"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "redis" {
  description                = "${var.prefix} Redis replication group"
  replication_group_id       = "${var.prefix}-redis"
  engine                     = "redis"
  engine_version             = "6.x"
  node_type                  = var.redis_node_type
  num_cache_clusters         = 1
  automatic_failover_enabled = false
  subnet_group_name          = aws_elasticache_subnet_group.cache_subnet_group.name
  security_group_ids         = [var.redis_security_group_id]
  preferred_cache_cluster_azs = [var.availability_zones[0]]
  port                        = 6379
  at_rest_encryption_enabled  = true
  transit_encryption_enabled  = true
  # TODO: add failover capability
  # automatic_failover_enabled = true
  # num_node_groups            = 2
  # replicas_per_node_group    = 1

  tags = {
    Name = "${var.prefix}-redis"
  }
}