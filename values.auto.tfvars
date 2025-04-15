#----------------------GENERAL----------------------#
aws_region = "us-east-1"

environment = "STAGING"

project_name = "test-project"

github_repo = "https://github.com/"

creator_name = "360MomsIT"

#----------------------STAGING----------------------#
stag_instance_type     = "t2.micro"
stag_ami_id            = "ami-0c2b8ca1dad447f8a"
stag_db_instance_class = "db.t2.micro"
stag_db_storage        = 5
stag_db_username       = "user"
stag_db_password       = "usersecretpassword"  # TODO: to be added to GH secrets
stag_redis_node_type   = "cache.t2.micro"

#----------------------PRODUCTION----------------------#
prod_instance_type     = "c7g.xlarge"
prod_ami_id            = "ami-06ffba82f092f48d7"
prod_db_instance_class = "db.r7g.xlarge"
prod_db_storage        = 20
prod_db_username       = "admin"
prod_db_password       = "adminsecretpassword"  # TODO: to be added to GH secrets
prod_redis_node_type   = "cache.r7g.xlarge"


vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
db_engine          = "mysql"
db_parameter_group = "default.mysql8.0"