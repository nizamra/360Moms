# CloudWatch Module Configuration
# This file defines the core monitoring and alerting configuration for all services

#----------------------Local Variables----------------------#
# Define local variables for monitoring configuration
locals {
  #----------------------Log Group Configuration----------------------#
  # Map of log group paths for each monitored component
  log_groups = var.group_paths # Direct mapping from input variables

  #----------------------Metric Filter Configuration----------------------#
  # Generate metric filters to track error patterns in logs
  log_metric_filters = {
    for key, path in local.log_groups : key => {
      log_group_name   = "${var.name_prefix}${path}"        # Full path with environment prefix
      pattern          = "ERROR"                            # Pattern to match in logs
      metric_name      = "${replace(path, "/", "-")}-error" # Metric name from path
      metric_namespace = "LogMetrics"                       # Custom namespace for log metrics
      metric_value     = 1                                  # Increment counter by 1 for each match
    }
  }

  #----------------------Alarm Specifications----------------------#
  # Build comprehensive alarm specifications for each service
  alarm_specs = {
    for service, namespace in var.alarm_namespace :
    service => {
      for metric_key, metric_name in var.alarm_metric :
      "${service}_${metric_key}" => {
        namespace = namespace                                # Service-specific namespace
        metric    = metric_name                              # Metric to monitor
        threshold = try(var.alarm_threshold[metric_key], 80) # Alert threshold with default
        dim       = try(var.alarm_dim[service], "")          # Dimension for the metric
        attr      = try(var.alarm_attr[service], "")         # Additional attributes
      }
      # Only create alarms where all required parameters are defined
      if contains(keys(var.alarm_dim), service) &&
      contains(keys(var.alarm_attr), service) &&
      contains(keys(var.alarm_threshold), metric_key)
    }
  }

  #----------------------Log-based Alarm Specifications----------------------#
  # Define alarms for specific error patterns across services
  log_alarm_specs = {
    # Nginx 5xx Error Monitoring
    nginx_5xx = {
      alarm_name  = "${var.name_prefix}-nginx-5xx"
      metric_name = lookup(var.alarm_metric, "nginx_5xx", "Nginx5xxErrorCount")
      threshold   = lookup(var.alarm_threshold, "nginx_5xx", 1) # Alert on any 5xx error
    }
    # RDS Error Monitoring
    rds_error = {
      alarm_name  = "${var.name_prefix}-rds-error"
      metric_name = lookup(var.alarm_metric, "rds_error", "RDSErrorCount")
      threshold   = lookup(var.alarm_threshold, "rds_error", 1) # Alert on database errors
    }
    # Redis Error Monitoring
    redis_err = {
      alarm_name  = "${var.name_prefix}-redis-error"
      metric_name = lookup(var.alarm_metric, "redis_err", "RedisErrorCount")
      threshold   = lookup(var.alarm_threshold, "redis_err", 1) # Alert on cache errors
    }
    # Application Error Monitoring
    app_error = {
      alarm_name  = "${var.name_prefix}-app-error"
      metric_name = lookup(var.alarm_metric, "app_error", "ApplicationErrorCount")
      threshold   = lookup(var.alarm_threshold, "app_error", 1) # Alert on application errors
    }
  }
}
