resource "aws_cloudwatch_log_group" "ecs" {

  name = "/ecs/${var.project_name}"

  retention_in_days = 30

}

resource "aws_cloudwatch_log_group" "thumbnail_lambda" {

  name = "/aws/lambda/${var.project_name}-thumbnail-generator"

  retention_in_days = 30

}

resource "aws_cloudwatch_log_group" "notification_lambda" {

  name = "/aws/lambda/${var.project_name}-notification"

  retention_in_days = 30

}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {

  alarm_name = "${var.project_name}-alb-5xx-errors"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "HTTPCode_Target_5XX_Count"

  namespace = "AWS/ApplicationELB"

  period = 300

  statistic = "Sum"

  threshold = 5

  alarm_actions = [
    aws_sns_topic.ops_alerts.arn
  ]

  alarm_description = "ALB target is returning 5XX errors"

  dimensions = {

    LoadBalancer = aws_lb.main.arn_suffix

  }

}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {

  alarm_name = "${var.project_name}-ecs-cpu-high"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/ECS"

  period = 300

  statistic = "Average"

  threshold = 80

  dimensions = {

    ClusterName = aws_ecs_cluster.main.name

    ServiceName = aws_ecs_service.api.name

  }

}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {

  alarm_name = "${var.project_name}-rds-cpu-high"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/RDS"

  period = 300

  statistic = "Average"

  threshold = 80

  alarm_actions = [
    aws_sns_topic.ops_alerts.arn
  ]

  alarm_description = "RDS CPU utilization is high"

  dimensions = {

    DBInstanceIdentifier = aws_db_instance.postgres.id

  }

}

resource "aws_cloudwatch_metric_alarm" "thumbnail_lambda_errors" {

  alarm_name = "${var.project_name}-thumbnail-lambda-errors"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "Errors"

  namespace = "AWS/Lambda"

  period = 300

  statistic = "Sum"

  threshold = 1

  alarm_actions = [
    aws_sns_topic.ops_alerts.arn
  ]

  alarm_description = "Thumbnail Lambda is failing"

  dimensions = {

    FunctionName = aws_lambda_function.thumbnail_generator.function_name

  }

}

resource "aws_cloudwatch_metric_alarm" "notification_lambda_errors" {

  alarm_name = "${var.project_name}-notification-lambda-errors"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "Errors"

  namespace = "AWS/Lambda"

  period = 300

  statistic = "Sum"

  threshold = 1

  alarm_actions = [
    aws_sns_topic.ops_alerts.arn
  ]

  alarm_description = "Notification Lambda is failing"

  dimensions = {

    FunctionName = aws_lambda_function.notification.function_name

  }

}

resource "aws_sns_topic" "ops_alerts" {

  name = "${var.project_name}-ops-alerts"

}

resource "aws_sns_topic_subscription" "ops_email" {

  topic_arn = aws_sns_topic.ops_alerts.arn

  protocol = "email"

  endpoint = var.ops_email

}
