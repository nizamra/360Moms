#----------------------GENERAL----------------------#
aws_region   = "me-south-1"
environment  = "staging"
project_name = "test-project"
github_repo  = "https://github.com/"
creator_name = "360MomsIT"

#----------------------staging----------------------#
stag_instance_type     = "t3.micro"
stag_ami_id            = "ami-05386f5b6125efb1f" # Ubuntu 22.04 LTS (me-south-1)
stag_db_instance_class = "db.t3.micro"
stag_db_storage        = 20
stag_db_storage_type   = "gp3"
stag_max_db_storage    = 60
stag_db_username       = "user"
stag_redis_node_type   = "cache.t2.micro"

#----------------------production----------------------#
prod_instance_type     = "t3.micro"
prod_ami_id            = "ami-05386f5b6125efb1f" # Ubuntu 22.04 LTS (me-south-1)
prod_db_instance_class = "db.t3.micro"
prod_db_storage        = 50
prod_db_storage_type   = "io1"
prod_max_db_storage    = 200
prod_db_username       = "admin"
prod_redis_node_type   = "cache.t2.micro"

#----------------------NETWORK----------------------#
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["me-south-1a", "me-south-1b"]

#----------------------DATABASE----------------------#
db_engine          = "mysql"
db_parameter_group = "mysql8.0"
