#----------------------GENERAL----------------------#
aws_region   = " eu-central-2"
name_prefix  = "staging"
project_name = "360-moms"
github_repo  = "https://github.com/"
creator_name = "Nizam"

#----------------------NETWORK----------------------#
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

#----------------------EC2----------------------#
instance_type = "t3.micro"
ami_id        = "ami-05386f5b6125efb1f" # Ubuntu 22.04 LTS (me-south-1)

#----------------------DATABASE----------------------#
db_instance_class = "db.t3.micro"
db_storage        = 20
db_storage_type   = "gp3"
max_db_storage    = 60
db_username       = "user"
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
  ec2   = "AutoScalingGroupName"
  rds   = "DBInstanceIdentifier"
  redis = "CacheClusterId"
}
alarm_attr = {
  ec2   = "asg_name"
  rds   = "rds_id"
  redis = "redis_id"
}
alarm_common_settings = {
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1   # number of periods
  period              = 300 # seconds
  statistic           = "Sum"
}
alarm_alert_email = "amin@360moms.net"
