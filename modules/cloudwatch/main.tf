locals {
  # Log groups are directly defined from the group_paths variable
  log_groups = var.group_paths

  # Generate log metric filters for all defined log groups
  log_metric_filters = {
    for key, path in local.log_groups : key => {
      log_group_name   = "${var.name_prefix}${path}"
      pattern          = "ERROR"
      metric_name      = "${replace(path, "/", "-")}-error"
      metric_namespace = "LogMetrics"
      metric_value     = 1
    }
  }

  # Build specs for alarms using attributes for each service type
  alarm_specs = {
    for service, namespace in var.alarm_namespace :
    service => {
      for metric_key, metric_name in var.alarm_metric :
      "${service}_${metric_key}" => {
        namespace = namespace
        metric    = metric_name
        threshold = try(var.alarm_threshold[metric_key], 80)
        dim       = try(var.alarm_dim[service], "")
        attr      = try(var.alarm_attr[service], "")
      }
      if contains(keys(var.alarm_dim), service) &&
      contains(keys(var.alarm_attr), service) &&
      contains(keys(var.alarm_threshold), metric_key)
    }
  }

  # Build specs for the log‑metric alarms
  log_alarm_specs = {
    nginx_5xx = {
      alarm_name  = "${var.name_prefix}-nginx-5xx"
      metric_name = lookup(var.alarm_metric, "nginx_5xx", "Nginx5xxErrorCount")
      threshold   = lookup(var.alarm_threshold, "nginx_5xx", 1)
    }
    rds_error = {
      alarm_name  = "${var.name_prefix}-rds-error"
      metric_name = lookup(var.alarm_metric, "rds_error", "RDSErrorCount")
      threshold   = lookup(var.alarm_threshold, "rds_error", 1)
    }
    redis_err = {
      alarm_name  = "${var.name_prefix}-redis-error"
      metric_name = lookup(var.alarm_metric, "redis_err", "RedisErrorCount")
      threshold   = lookup(var.alarm_threshold, "redis_err", 1)
    }
    app_error = {
      alarm_name  = "${var.name_prefix}-app-error"
      metric_name = lookup(var.alarm_metric, "app_error", "ApplicationErrorCount")
      threshold   = lookup(var.alarm_threshold, "app_error", 1)
    }
  }
}
