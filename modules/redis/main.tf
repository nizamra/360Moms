# Redis Module Configuration
# This file defines the Amazon ElastiCache Redis cluster configuration for the application's caching layer

# Primary Redis Cluster
# Creates a managed Redis cluster for high-performance caching
resource "aws_elasticache_cluster" "redis" {
  # Basic Cluster Configuration
  cluster_id      = "${var.name_prefix}-redis" # Unique identifier for the Redis cluster
  engine          = "redis"                    # Using Redis as the cache engine
  node_type       = var.redis_node_type        # Instance type determining memory and compute capacity
  num_cache_nodes = var.num_cache_nodes        # Number of cache nodes in the cluster

  # Network Configuration
  subnet_group_name  = var.redis_subnet_group_name   # Subnet group for cluster placement
  security_group_ids = [var.redis_security_group_id] # Security group controlling access

  # Resource Tags
  tags = {
    Name = "${var.name_prefix}-redis" # Resource name tag
  }
}
