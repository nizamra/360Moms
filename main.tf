# Main Terraform Configuration File
# This file orchestrates the entire infrastructure deployment by combining various modules

# Local Variables Block
# Defines environment-specific configurations based on the current workspace (production or staging)
locals {
  # Determines instance type based on the workspace
  instance_type = terraform.workspace == "production" ? var.prod_instance_type : var.stage_instance_type
  # Sets database storage size based on the workspace
  db_storage = terraform.workspace == "production" ? var.prod_db_storage : var.stage_db_storage
  # Configures maximum database storage based on the workspace
  max_db_storage = terraform.workspace == "production" ? var.prod_max_db_storage : var.stage_max_db_storage
  # Sets database username based on the workspace
  db_username = terraform.workspace == "production" ? var.prod_db_username : var.stage_db_username
  # Configures IAM authentication settings based on the workspace
  iam_authentication = terraform.workspace == "production" ? var.prod_iam_authentication : var.stage_iam_authentication
}

# Network Module Block
# Creates the VPC infrastructure including subnets, route tables, and networking components
module "network" {
  source             = "./modules/network"
  name_prefix        = terraform.workspace
  public_subnets     = var.public_subnets     # CIDR blocks for public subnets
  private_subnets    = var.private_subnets    # CIDR blocks for private subnets
  availability_zones = var.availability_zones # AZs where the infrastructure will be deployed
  vpc_cidr           = var.vpc_cidr           # Main VPC CIDR block
}

# RDS Module Block
# Provisions and configures the Amazon RDS database instance
module "rds" {
  source               = "./modules/rds"
  name_prefix          = terraform.workspace
  db_engine            = var.db_engine         # Database engine type
  db_instance_class    = var.db_instance_class # RDS instance size
  db_storage           = local.db_storage      # Initial storage allocation
  db_storage_type      = var.db_storage_type   # Storage type (e.g., gp2, io1)
  max_db_storage       = local.max_db_storage  # Maximum storage limit
  db_username          = local.db_username     # Database admin username
  db_password          = var.db_password       # Database admin password
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.network.rds_security_group_id
  db_subnet_group_name = module.network.rds_subnet_group_name
  iam_authentication   = local.iam_authentication # IAM authentication settings
}

# Redis Module Block
# Sets up Amazon ElastiCache for Redis cluster
module "redis" {
  source                  = "./modules/redis"
  name_prefix             = terraform.workspace
  redis_node_type         = var.redis_node_type # Instance type for Redis nodes
  redis_security_group_id = module.network.redis_security_group_id
  redis_subnet_group_name = module.network.redis_subnet_group_name
  num_cache_nodes         = var.num_cache_nodes # Number of cache nodes in the cluster
}

# EC2 Module Block
# Deploys and configures EC2 instances for the application
module "ec2" {
  source             = "./modules/ec2"
  name_prefix        = terraform.workspace
  aws_region         = var.aws_region      # AWS region for deployment
  ami_id             = var.ami_id          # AMI ID for EC2 instances
  instance_type      = local.instance_type # EC2 instance size
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.network.security_group_id
  redis_endpoint     = module.redis.redis_endpoint # Redis connection endpoint
  db_endpoint        = module.rds.db_endpoint      # RDS connection endpoint
  db_resource_id     = module.rds.db_resource_id
  db_username        = local.db_username
  db_password        = var.db_password
  depends_on         = [module.network, module.rds, module.redis] # Ensures proper deployment order
}

# CloudWatch Module Block
# Configures monitoring, logging, and alerting for all infrastructure components
module "cloudwatch" {
  source                = "./modules/cloudwatch"
  name_prefix           = terraform.workspace
  aws_region            = var.aws_region
  vpc_id                = module.network.vpc_id
  ec2_instance_id       = module.ec2.ec2_instance_id # EC2 instance to monitor
  rds_identifier        = module.rds.db_identifier   # RDS instance to monitor
  redis_cluster_id      = module.redis.redis_id      # Redis cluster to monitor
  alarm_alert_email     = var.alarm_alert_email      # Email for alarm notifications
  create_rds_alarms     = true                       # Enable RDS monitoring
  create_redis_alarms   = true                       # Enable Redis monitoring
  retention_in_days     = var.retention_in_days      # Log retention period
  group_paths           = var.group_paths            # Log group paths
  alarm_namespace       = var.alarm_namespace        # CloudWatch namespace
  alarm_metric          = var.alarm_metric           # Metrics to monitor
  alarm_threshold       = var.alarm_threshold        # Alarm thresholds
  alarm_dim             = var.alarm_dim              # Alarm dimensions
  alarm_attr            = var.alarm_attr             # Alarm attributes
  alarm_common_settings = var.alarm_common_settings  # Common alarm configurations

  depends_on = [module.network, module.ec2, module.rds, module.redis] # Ensures proper deployment order
}
