# CloudWatch Log Groups Configuration
# This file defines the log groups and metric filters for application monitoring

#----------------------Log Groups----------------------#
# Create log groups for each monitored component
resource "aws_cloudwatch_log_group" "log_group" {
  for_each = local.log_groups # Create groups based on defined paths

  name              = "${var.name_prefix}${each.value}" # Full log group name with prefix
  retention_in_days = var.retention_in_days             # Log retention period
  tags              = { VpcId = var.vpc_id }            # Tag with VPC for organization
}

#----------------------Metric Filters----------------------#
# Create metric filters to track error patterns in logs
resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each = local.log_metric_filters # Create filters for each log group

  # Filter Configuration
  name           = "${replace(each.value.log_group_name, "/", "-")}-errors" # Unique filter name
  pattern        = each.value.pattern                                       # Pattern to match in logs (e.g., "ERROR")
  log_group_name = each.value.log_group_name                                # Associated log group

  # Metric Configuration
  metric_transformation {
    name      = each.value.metric_name      # Name of the generated metric
    namespace = each.value.metric_namespace # Metric namespace for organization
    value     = each.value.metric_value     # Value to record when pattern matches
  }

  # Ensure log groups exist before creating filters
  depends_on = [aws_cloudwatch_log_group.log_group]
}
