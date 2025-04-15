locals {
  name_prefix = var.environment
}

# Staging Environment
module "staging" {
  source      = "./modules/environment"
  environment = "STAGING"
  aws_region  = var.aws_region
  prefix      = local.name_prefix

  instance_type      = var.stag_instance_type
  ami_id             = var.stag_ami_id
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
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
  source      = "./modules/environment"
  environment = "PRODUCTION"
  aws_region  = var.aws_region
  prefix      = local.name_prefix

  instance_type      = var.prod_instance_type
  ami_id             = var.prod_ami_id
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  db_engine          = var.db_engine
  db_parameter_group = var.db_parameter_group
  db_instance_class  = var.prod_db_instance_class
  db_storage         = var.prod_db_storage
  db_username        = var.prod_db_username
  db_password        = var.prod_db_password
  redis_node_type    = var.prod_redis_node_type
}