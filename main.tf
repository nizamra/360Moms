module "network" {
  source             = "./modules/network"
  prefix             = var.name_prefix
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
}

module "ec2" {
  source                                = "./modules/ec2"
  prefix                                = var.name_prefix
  aws_region                            = var.aws_region
  ami_id                                = var.ami_id
  instance_type                         = var.instance_type
  private_subnet_ids                    = module.network.private_subnet_ids
  security_group_id                     = module.network.security_group_id
  target_group_arn                      = module.network.target_group_arn
  redis_endpoint                        = module.redis.redis_endpoint
  db_endpoint                           = module.rds.rds_endpoint
  db_resource_id                        = module.rds.db_resource_id
  db_username                           = var.db_username
  db_password                           = var.db_password
  autoscaling_desired_capacity          = var.autoscaling_desired_capacity
  autoscaling_max_size                  = var.autoscaling_max_size
  autoscaling_min_size                  = var.autoscaling_min_size
  autoscaling_health_check_type         = var.autoscaling_health_check_type
  autoscaling_health_check_grace_period = var.autoscaling_health_check_grace_period
}

module "rds" {
  source               = "./modules/rds"
  prefix               = var.name_prefix
  db_engine            = var.db_engine
  db_instance_class    = var.db_instance_class
  db_storage           = var.db_storage
  db_storage_type      = var.db_storage_type
  max_db_storage       = var.max_db_storage
  db_username          = var.db_username
  db_password          = var.db_password
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.network.rds_security_group_id
  db_subnet_group_name = module.network.rds_subnet_group_name
  iam_authentication   = var.iam_authentication
}

module "redis" {
  source                  = "./modules/redis"
  prefix                  = var.name_prefix
  redis_node_type         = var.redis_node_type
  redis_security_group_id = module.network.redis_security_group_id
  redis_subnet_group_name = module.network.redis_subnet_group_name
  redis_cache_clusters    = var.redis_cache_clusters
}

# module "cloudwatch" {
#   source     = "./modules/cloudwatch"
#   prefix     = var.name_prefix
#   aws_region = var.aws_region
#   vpc_id     = module.network.vpc_id

#   ec2_instance_id  = module.ec2.ec2_instance_id
#   rds_identifier   = module.rds.rds_identifier
#   redis_cluster_id = module.redis.redis_cluster_id
#   alert_email           = "alerts@example.com" # TODO: Replace with actual email address

#   depends_on = [module.network, module.ec2, module.rds, module.redis]
# }
