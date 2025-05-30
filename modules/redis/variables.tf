variable "name_prefix" {
  description = "Prefix for resources"
  type        = string
}

variable "redis_node_type" {
  description = "The node type for Redis cluster"
  type        = string
}

variable "redis_security_group_id" {
  description = "The ID of the security group for Redis"
  type        = string
}

variable "redis_subnet_group_name" {
  description = "The name of the Redis subnet group"
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes in the cluster"
  type        = number
}
