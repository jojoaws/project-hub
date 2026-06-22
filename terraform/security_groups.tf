resource "aws_security_group" "alb" {

  name = "${var.project_name}-alb-sg"

  description = "ALB security group"

  vpc_id = module.networking.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-alb-sg"

  }

}

resource "aws_security_group" "ecs" {

  name = "${var.project_name}-ecs-sg"

  description = "ECS security group"

  vpc_id = module.networking.vpc_id

  ingress {

    from_port = 8000

    to_port = 8000

    protocol = "tcp"

    security_groups = [aws_security_group.alb.id]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-ecs-sg"

  }

}

resource "aws_security_group" "rds" {

  name = "${var.project_name}-rds-sg"

  description = "RDS security group"

  vpc_id = module.networking.vpc_id

  ingress {

    from_port = 5432

    to_port = 5432

    protocol = "tcp"

    security_groups = [aws_security_group.ecs.id]

  }

  ingress {

    from_port = 5432

    to_port = 5432

    protocol = "tcp"

    security_groups = [
      aws_security_group.bastion.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-rds-sg"

  }

}


