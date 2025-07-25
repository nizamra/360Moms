# Redis Module Variables
# This file defines all input variables required for the Redis module configuration

#----------------------Resource Naming----------------------#
# Prefix used for naming Redis resources
variable "name_prefix" {
  description = "Prefix for resources"
  type        = string # Example: "prod" or "staging"
}

#----------------------Cluster Configuration----------------------#
# Node type and capacity settings
variable "redis_node_type" {
  description = "The node type for Redis cluster"
  type        = string # Example: "cache.t3.micro" or "cache.m4.large"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes in the cluster"
  type        = number # Number of nodes for scalability and redundancy
}

#----------------------Network Configuration----------------------#
# Network security and placement settings
variable "redis_security_group_id" {
  description = "The ID of the security group for Redis"
  type        = string # Controls network access to the Redis cluster
}

variable "redis_subnet_group_name" {
  description = "The name of the Redis subnet group"
  type        = string # Determines subnet placement of the Redis cluster
}
