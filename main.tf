# Main Terraform Configuration File
# This file orchestrates the entire infrastructure deployment by combining various modules

# Local Variables Block
# Defines environment-specific configurations based on the current workspace (prod or dev)
locals {
  # Determines instance type based on the workspace
  instance_type = terraform.workspace == "prod" ? var.prod_instance_type : var.stage_instance_type
  # Sets database storage size based on the workspace
  db_storage = terraform.workspace == "prod" ? var.prod_db_storage : var.stage_db_storage
  # Configures maximum database storage based on the workspace
  max_db_storage = terraform.workspace == "prod" ? var.prod_max_db_storage : var.stage_max_db_storage
  # Sets database username based on the workspace
  db_username = terraform.workspace == "prod" ? var.prod_db_username : var.stage_db_username
  # Configures IAM authentication settings based on the workspace
  iam_authentication = terraform.workspace == "prod" ? var.prod_iam_authentication : var.stage_iam_authentication
}

# Network Module Block
# Creates the VPC infrastructure including subnets, route tables, and networking components
module "network" {
  source             = "./modules/network"
  name_prefix        = terraform.workspace
  public_subnets     = var.public_subnets                                       # CIDR blocks for public subnets
  private_subnets    = var.private_subnets                                      # CIDR blocks for private subnets
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2) # AZs where the infrastructure will be deployed
  vpc_cidr           = var.vpc_cidr                                             # Main VPC CIDR block
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
  depends_on         = [module.network, module.rds] # Ensures proper deployment order
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}
