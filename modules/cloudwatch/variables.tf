#----------------------GENERAL----------------------#
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
}

variable "alarm_alert_email" {
  description = "Email address to send CloudWatch alerts to"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for CloudWatch resources"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

#----------------------RESOURCES----------------------#
variable "ec2_instance_id" {
  description = "ID of the EC2 instance to monitor"
  type        = string
}

variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "redis_cluster_id" {
  description = "ElastiCache Redis cluster id"
  type        = string
}

#----------------------ALARM FLAGS----------------------#
variable "create_ec2_alarms" {
  description = "Whether to create EC2 instance alarms"
  type        = bool
  default     = true
}

variable "create_rds_alarms" {
  description = "Whether to create RDS alarms"
  type        = bool
}

variable "create_redis_alarms" {
  description = "Whether to create Redis alarms"
  type        = bool
}

#----------------------CLOUDWATCH----------------------#
variable "group_paths" {
  description = "Paths to the log groups to monitor"
  type        = map(string)
}

variable "retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
}

variable "alarm_namespace" {
  description = "Namespace for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_metric" {
  description = "Metrics for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_threshold" {
  description = "Thresholds for CloudWatch alarms"
  type        = map(any)
}

variable "alarm_dim" {
  description = "Dimensions for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_attr" {
  description = "Attributes for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_common_settings" {
  description = "Common settings for CloudWatch alarms"
  type        = map(any)
}
