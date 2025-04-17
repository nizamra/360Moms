locals {
  name_prefix = var.environment
}

module "network" {
  source             = "./modules/network"
  aws_region         = var.aws_region
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
}

# Staging Environment
module "staging" {
  source             = "./modules/environment"
  environment        = "staging"
  aws_region         = var.aws_region
  prefix             = local.name_prefix
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.network.security_group_id

  instance_type      = var.stag_instance_type
  ami_id             = var.stag_ami_id
  db_engine          = var.db_engine
  db_parameter_group = var.db_parameter_group
  db_instance_class  = var.stag_db_instance_class
  db_storage         = var.stag_db_storage
  db_username        = var.stag_db_username
  db_password        = var.stag_db_password
  redis_node_type    = var.stag_redis_node_type
}

# Production Environment
module "production" {
  source             = "./modules/environment"
  environment        = "production"
  aws_region         = var.aws_region
  prefix             = local.name_prefix
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.network.security_group_id

  instance_type      = var.prod_instance_type
  ami_id             = var.prod_ami_id
  db_engine          = var.db_engine
  db_parameter_group = var.db_parameter_group
  db_instance_class  = var.prod_db_instance_class
  db_storage         = var.prod_db_storage
  db_username        = var.prod_db_username
  db_password        = var.prod_db_password
  redis_node_type    = var.prod_redis_node_type
}

module "cloudwatch" {
  source     = "./modules/cloudwatch"
  aws_region = var.aws_region
  vpc_id     = module.network.vpc_id

  # Resource IDs for monitoring
  stag_ec2_instance_id  = module.staging.ec2_instance_id
  stag_rds_identifier   = module.staging.rds_identifier
  stag_redis_cluster_id = module.staging.redis_cluster_id
  prod_ec2_instance_id  = module.production.ec2_instance_id
  prod_rds_identifier   = module.production.rds_identifier
  prod_redis_cluster_id = module.production.redis_cluster_id
  alert_email           = "alerts@example.com" # TODO: Replace with actual email address

  depends_on = [module.network, module.staging, module.production]
}
