locals {
  name_prefix = var.environment
}

module "network" {
  source             = "./modules/network"
  prefix             = local.name_prefix
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
}

module "ec2" {
  source             = "./modules/ec2"
  prefix             = "staging"
  ami_id             = var.stag_ami_id
  instance_type      = var.stag_instance_type
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.network.security_group_id
  rds_endpoint       = module.rds.rds_endpoint
  redis_endpoint     = module.redis.redis_endpoint
  db_username        = var.stag_db_username
  db_password        = var.stag_db_password
}

module "rds" {
  source                = "./modules/rds"
  prefix                = "staging"
  db_engine             = var.db_engine
  db_instance_class     = var.stag_db_instance_class
  db_storage            = var.stag_db_storage
  db_storage_type       = var.stag_db_storage_type
  max_db_storage        = var.stag_max_db_storage
  db_username           = var.stag_db_username
  db_password           = var.stag_db_password
  private_subnet_ids    = module.network.private_subnet_ids
  rds_security_group_id = module.network.rds_security_group_id
  rds_subnet_group_name = module.network.rds_subnet_group_name
}

module "redis" {
  source                  = "./modules/redis"
  prefix                  = "staging"
  redis_node_type         = var.stag_redis_node_type
  private_subnet_ids      = module.network.private_subnet_ids
  redis_security_group_id = module.network.redis_security_group_id
  redis_subnet_group_name = module.network.redis_subnet_group_name
}

module "cloudwatch" {
  source     = "./modules/cloudwatch"
  aws_region = var.aws_region
  vpc_id     = module.network.vpc_id

  stag_ec2_instance_id  = module.ec2.ec2_instance_id
  stag_rds_identifier   = module.rds.rds_identifier
  stag_redis_cluster_id = module.redis.redis_cluster_id
  alert_email           = "alerts@example.com" # TODO: Replace with actual email address

  depends_on = [module.network, module.ec2, module.rds, module.redis]
}
