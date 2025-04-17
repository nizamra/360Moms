# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.environment}-redis-subnet-group"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "redis" {
  description          = "${var.environment} Redis replication group"
  replication_group_id = "${var.environment}-redis"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_clusters   = 1
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [var.security_group_id]
  # Use only one AZ since we have one cluster
  preferred_cache_cluster_azs = [var.availability_zones[0]]
  port                        = 6379

  tags = {
    Name = "${var.environment}-redis"
  }
}
