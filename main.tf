locals {
  instance_type        = terraform.workspace == "production" ? var.prod_instance_type : var.stage_instance_type
  db_storage           = terraform.workspace == "production" ? var.prod_db_storage : var.stage_db_storage
  max_db_storage       = terraform.workspace == "production" ? var.prod_max_db_storage : var.stage_max_db_storage
  db_username          = terraform.workspace == "production" ? var.prod_db_username : var.stage_db_username
  iam_authentication   = terraform.workspace == "production" ? var.prod_iam_authentication : var.stage_iam_authentication
  redis_cache_clusters = terraform.workspace == "production" ? var.prod_redis_cache_clusters : var.stage_redis_cache_clusters
}

module "network" {
  source             = "./modules/network"
  name_prefix        = terraform.workspace
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
}

module "rds" {
  source               = "./modules/rds"
  name_prefix          = terraform.workspace
  db_engine            = var.db_engine
  db_instance_class    = var.db_instance_class
  db_storage           = local.db_storage
  db_storage_type      = var.db_storage_type
  max_db_storage       = local.max_db_storage
  db_username          = local.db_username
  db_password          = var.db_password
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.network.rds_security_group_id
  db_subnet_group_name = module.network.rds_subnet_group_name
  iam_authentication   = local.iam_authentication
}

module "redis" {
  source                  = "./modules/redis"
  name_prefix             = terraform.workspace
  redis_node_type         = var.redis_node_type
  redis_security_group_id = module.network.redis_security_group_id
  redis_subnet_group_name = module.network.redis_subnet_group_name
  redis_cache_clusters    = local.redis_cache_clusters
}

module "ec2" {
  source                                = "./modules/ec2"
  name_prefix                           = terraform.workspace
  aws_region                            = var.aws_region
  ami_id                                = var.ami_id
  instance_type                         = local.instance_type
  private_subnet_ids                    = module.network.private_subnet_ids
  security_group_id                     = module.network.security_group_id
  target_group_arn                      = module.network.target_group_arn
  redis_endpoint                        = module.redis.redis_endpoint
  db_endpoint                           = module.rds.db_endpoint
  db_resource_id                        = module.rds.db_resource_id
  db_username                           = local.db_username
  db_password                           = var.db_password
  autoscaling_desired_capacity          = var.autoscaling_desired_capacity
  autoscaling_max_size                  = var.autoscaling_max_size
  autoscaling_min_size                  = var.autoscaling_min_size
  autoscaling_health_check_type         = var.autoscaling_health_check_type
  autoscaling_health_check_grace_period = var.autoscaling_health_check_grace_period
  depends_on                            = [module.network, module.rds, module.redis]
}

module "cloudwatch" {
  source            = "./modules/cloudwatch"
  name_prefix       = terraform.workspace
  aws_region        = var.aws_region
  vpc_id            = module.network.vpc_id
  ec2_instance_id   = module.ec2.ec2_instance_id
  rds_identifier    = module.rds.db_identifier
  redis_cluster_id  = module.redis.redis_cluster_id
  alarm_alert_email = var.alarm_alert_email
  env_configs = {
    asg_name = module.ec2.autoscaling_group_name
    rds_id   = module.rds.db_identifier
    redis_id = module.redis.redis_cluster_id
  }
  create_asg_alarms     = true
  create_rds_alarms     = true
  create_redis_alarms   = true
  retention_in_days     = var.retention_in_days
  group_paths           = var.group_paths
  alarm_namespace       = var.alarm_namespace
  alarm_metric          = var.alarm_metric
  alarm_threshold       = var.alarm_threshold
  alarm_dim             = var.alarm_dim
  alarm_attr            = var.alarm_attr
  alarm_common_settings = var.alarm_common_settings

  depends_on = [module.network, module.ec2, module.rds, module.redis]
}
