resource "aws_cloudwatch_log_group" "log_group" {
  for_each = local.log_groups

  name              = "${var.name_prefix}${each.value}"
  retention_in_days = var.retention_in_days
  tags              = { VpcId = var.vpc_id }
}

# CloudWatch Log Metrics Filter for Application Errors
resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each = local.log_metric_filters

  name           = "${replace(each.value.log_group_name, "/", "-")}-errors"
  pattern        = each.value.pattern
  log_group_name = each.value.log_group_name

  metric_transformation {
    name      = each.value.metric_name
    namespace = each.value.metric_namespace
    value     = each.value.metric_value
  }

  depends_on = [aws_cloudwatch_log_group.log_group]
}
