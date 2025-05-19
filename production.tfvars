#----------------------GENERAL----------------------#
aws_region   = "me-south-1"
name_prefix  = "staging"
environment  = "staging"
project_name = "test-project"
github_repo  = "https://github.com/"
creator_name = "360MomsIT"

#----------------------NETWORK----------------------#
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["me-south-1a", "me-south-1b"]

#----------------------EC2----------------------#
instance_type = "t3.micro"
ami_id        = "ami-05386f5b6125efb1f" # Ubuntu 22.04 LTS (me-south-1)

#----------------------DATABASE----------------------#
db_instance_class = "db.t3.micro"
db_storage        = 50
db_storage_type   = "gp3"
max_db_storage    = 200
db_username       = "admin"
redis_node_type   = "cache.t3.micro"
db_engine         = "mysql"

#----------------------AUTOSCALING----------------------#
autoscaling_desired_capacity          = 2
autoscaling_max_size                  = 4
autoscaling_min_size                  = 2
autoscaling_health_check_type         = "ELB"
autoscaling_health_check_grace_period = 300

#----------------------IAM----------------------#
iam_authentication = true # TODO: Change to false in production

#----------------------REDIS----------------------#
redis_cache_clusters = 1 # TODO: Change to 2 in production
