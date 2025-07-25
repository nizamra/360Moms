#----------------------GENERAL----------------------#
aws_region   = "eu-central-1"
project_name = "360moms"
github_repo  = "https://github.com/nizamra/360Moms"
creator_name = "Amin M."

#----------------------NETWORK----------------------#
vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

#----------------------EC2----------------------#
stage_instance_type = "t3.micro"
prod_instance_type  = "t3.micro"
ami_id              = "ami-0a87a69d69fa289be" # Ubuntu 22.04 LTS (eu-central-1)

#----------------------DATABASE----------------------#
db_instance_class    = "db.t3.micro"
stage_db_storage     = "20"
prod_db_storage      = "50"
db_storage_type      = "gp3"
stage_max_db_storage = "60"
prod_max_db_storage  = "200"
stage_db_username    = "user"
prod_db_username     = "admin"
db_engine            = "mysql"
num_cache_nodes      = 1

#----------------------IAM----------------------#
stage_iam_authentication = "true"
prod_iam_authentication  = "false"
