resource "aws_ecs_cluster" "main" {

  name = "${var.project_name}-cluster"

}

resource "aws_ecs_task_definition" "api" {

  family = "${var.project_name}-api"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = 512

  memory = 1024

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {

      name = "api"

      image = "${aws_ecr_repository.api.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]

      secrets = [
        {
          name      = "DB_SECRET_ARN"
          valueFrom = aws_secretsmanager_secret.db_credentials.arn
        }
      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"

        }

      }

    }

  ])

}

resource "aws_ecs_service" "api" {

  name = "${var.project_name}-api"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.api.arn

  desired_count = 2

  launch_type = "FARGATE"

  deployment_minimum_healthy_percent = 100

  deployment_maximum_percent = 200

  network_configuration {

    subnets = [
      module.networking.private_subnet_a_id,
      module.networking.private_subnet_b_id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.api.arn

    container_name = "api"

    container_port = 8000

  }

  depends_on = [
    aws_lb_listener.http
  ]

}
