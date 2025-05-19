variable "prefix" {
  description = "Prefix for resources"
  type        = string
}

variable "db_engine" {
  description = "The database engine type"
  type        = string
}

variable "db_instance_class" {
  description = "The database instance class"
  type        = string
}

variable "db_storage" {
  description = "The allocated database storage in GB"
  type        = number
}

variable "db_storage_type" {
  description = "The storage type for the database (e.g., gp2, io1)"
  type        = string
}

variable "max_db_storage" {
  description = "The maximum storage limit for autoscaling"
  type        = number
}

variable "db_username" {
  description = "The database admin username"
  type        = string
}

variable "db_password" {
  description = "The database admin password"
  type        = string
}

variable "rds_security_group_id" {
  description = "The ID of the security group for RDS"
  type        = string
}

variable "rds_subnet_group_name" {
  description = "The name of the RDS subnet group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}
