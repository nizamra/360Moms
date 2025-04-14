# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.environment}-redis-subnet-group"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "redis" {
  description                 = "${var.environment} Redis replication group"
  replication_group_id        = "${var.environment}-redis"
  engine                      = "redis"
  node_type                   = var.redis_node_type
  num_cache_clusters          = 1
  automatic_failover_enabled  = true
  subnet_group_name           = aws_elasticache_subnet_group.this.name
  security_group_ids          = [aws_security_group.ec2.id]
  preferred_cache_cluster_azs = var.availability_zones
  port                        = 6379

  tags = {
    Name = "${var.environment}-redis"
  }
}
