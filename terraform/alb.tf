resource "aws_lb" "main" {

  name = "${var.project_name}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    module.networking.public_subnet_a_id,
    module.networking.public_subnet_b_id
  ]

}

resource "aws_lb_target_group" "api" {

  name = "${var.project_name}-tg"

  port = 8000

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = module.networking.vpc_id

  health_check {

    path = "/health"

    protocol = "HTTP"

    matcher = "200"

  }

}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.main.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.api.arn

  }

}
