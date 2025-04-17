#----------------------GENERAL----------------------#
aws_region   = "us-east-1"
environment  = "STAGING"
project_name = "test-project"
github_repo  = "https://github.com/"
creator_name = "360MomsIT"

#----------------------STAGING----------------------#
stag_instance_type     = "t2.micro"
stag_ami_id            = "ami-0c2b8ca1dad447f8a"
stag_db_instance_class = "db.t2.micro"
stag_db_storage        = 5
stag_db_username       = "user"
stag_redis_node_type   = "cache.t2.micro"

#----------------------PRODUCTION----------------------#
prod_instance_type     = "t2.micro"
prod_ami_id            = "ami-0c2b8ca1dad447f8a"
prod_db_instance_class = "db.t2.micro"
prod_db_storage        = 20
prod_db_username       = "admin"
prod_redis_node_type   = "cache.t2.micro"

#----------------------NETWORK----------------------#
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

#----------------------DATABASE----------------------#
db_engine          = "mysql"
db_parameter_group = "default.mysql8.0"