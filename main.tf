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
  db_instance_class  = var.db_instance_class
  db_storage         = var.db_storage
  db_username        = var.db_username
  db_password        = var.db_password
  db_parameter_group = var.db_parameter_group
  redis_node_type    = var.redis_node_type
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
  db_instance_class  = var.db_instance_class
  db_storage         = var.db_storage
  db_username        = var.db_username
  db_password        = var.db_password
  db_parameter_group = var.db_parameter_group
  redis_node_type    = var.redis_node_type
}