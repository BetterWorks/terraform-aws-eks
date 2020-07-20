resource "aws_cloudwatch_metric_alarm" "eks_node_cpu_utilization_too_high" {
  alarm_name          = "${var.alert_name_prefix}_eks_node_cpu_utilization_too_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  datapoints_to_alarm = "3"
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "eks cluster average cpu utilization greater than desired"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_node_memory_utilization_too_high" {
  alarm_name          = "${var.alert_name_prefix}_eks_node_memory_utilization_too_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  datapoints_to_alarm = "3"
  metric_name         = "node_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "60"
  statistic           = "Average"
  threshold           = var.memory_threshold
  alarm_description   = "eks cluster average cpu utilization greater than desired"
  alarm_actions       = [aws_sns_topic.default.arn]
  ok_actions          = [aws_sns_topic.default.arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}
