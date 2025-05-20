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
    for group_name, path in var.group_paths : group_name => {
      alarm_name  = "${var.name_prefix}-${group_name}-error-alarm"
      metric_name = "${var.name_prefix}-${group_name}-error-metric"
      threshold   = 1
    }
  }
}
