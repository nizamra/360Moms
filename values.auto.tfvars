#----------------------GENERAL----------------------#
aws_region   = "me-south-1"
project_name = "threesixtymom-project"
github_repo  = "https://github.com/"
creator_name = "360MomsIT"

#----------------------NETWORK----------------------#
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["me-south-1a", "me-south-1b"]

#----------------------EC2----------------------#
stage_instance_type = "t2.micro"
prod_instance_type  = "t3.micro"
ami_id              = "ami-05386f5b6125efb1f" # Ubuntu 22.04 LTS (me-south-1)

#----------------------DATABASE----------------------#
db_instance_class    = "db.t3.micro"
stage_db_storage     = "20"
prod_db_storage      = "50"
db_storage_type      = "gp3"
stage_max_db_storage = "60"
prod_max_db_storage  = "200"
stage_db_username    = "user"
prod_db_username     = "admin"
redis_node_type      = "cache.t3.micro"
db_engine            = "mysql"

#----------------------IAM----------------------#
stage_iam_authentication = "true"
prod_iam_authentication  = "false"

#----------------------CLOUDWATCH----------------------#
group_paths = {
  application = "/aws/ec2/application"
  nginx       = "/aws/ec2/nginx"
  system      = "/aws/ec2/system"
  rds         = "/aws/rds/mysql-logs"
  redis       = "/aws/elasticache/redis-logs"
}
retention_in_days = 7 # days
alarm_namespace = {
  ec2   = "AWS/EC2"
  rds   = "AWS/RDS"
  redis = "AWS/ElastiCache"
  logs  = "LogMetrics"
}
alarm_metric = {
  cpu        = "CPUUtilization"
  memory     = "FreeableMemory"
  conn       = "DatabaseConnections"
  redis_conn = "CurrConnections"
  # log‑derived metrics
  nginx_5xx = "Nginx5xxErrorCount"
  rds_error = "RDSErrorCount"
  redis_err = "RedisErrorCount"
  app_error = "ApplicationErrorCount"
}
alarm_threshold = {
  cpu        = 80        # percent
  memory     = 200000000 # bytes
  conn       = 100       # number of connections
  redis_conn = 100       # number of connections

  # all log metrics trip at 1
  nginx_5xx = 1 # count
  rds_error = 1 # count
  redis_err = 1 # count
  app_error = 1 # count
}
alarm_dim = {
  ec2   = "InstanceId"
  rds   = "DBInstanceIdentifier"
  redis = "CacheClusterId"
}
alarm_attr = {
  ec2   = "instance_id"
  rds   = "rds_id"
  redis = "redis_id"
}
alarm_common_settings = {
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1   # number of periods
  period              = 300 # seconds
  statistic           = "Average"
}
alarm_alert_email = "alerts@example.com"
