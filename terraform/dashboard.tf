resource "aws_cloudwatch_dashboard" "projecthub" {

  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({

    widgets = [

      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "ECS CPU Utilization",

          "metrics" : [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              aws_ecs_cluster.main.name,
              "ServiceName",
              aws_ecs_service.api.name
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Average"
        }
      },

      {
        "type" : "metric",
        "x" : 12,
        "y" : 0,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "ECS Memory Utilization",

          "metrics" : [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              aws_ecs_cluster.main.name,
              "ServiceName",
              aws_ecs_service.api.name
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Average"
        }
      },

      {
        "type" : "metric",
        "x" : 0,
        "y" : 6,
        "width" : 12,
        "height" : 6,

        "properties" : {

          "title" : "Lambda Invocations",

          "metrics" : [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              aws_lambda_function.notification.function_name
            ]
          ],

          "region" : var.aws_region
        }
      },

      {
        "type" : "metric",
        "x" : 0,
        "y" : 12,
        "width" : 12,
        "height" : 6,

        "properties" : {

          "title" : "RDS CPU Utilization",

          "metrics" : [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              aws_db_instance.postgres.identifier
            ]
          ],

          "region" : var.aws_region,
          "stat" : "Average"
        }
      },

      {
        "type" : "metric",
        "x" : 12,
        "y" : 12,
        "width" : 12,
        "height" : 6,

        "properties" : {

          "title" : "Database Connections",

          "metrics" : [
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              aws_db_instance.postgres.identifier
            ]
          ],

          "region" : var.aws_region
        }
      },

      {
        "type" : "metric",
        "x" : 12,
        "y" : 6,
        "width" : 12,
        "height" : 6,

        "properties" : {

          "title" : "Lambda Errors",

          "metrics" : [
            [
              "AWS/Lambda",
              "Errors",
              "FunctionName",
              aws_lambda_function.notification.function_name
            ]
          ],

          "region" : var.aws_region
        }
      }

    ]

  })

}
