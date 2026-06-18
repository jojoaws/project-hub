resource "aws_db_subnet_group" "main" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    module.networking.private_subnet_a_id,
    module.networking.private_subnet_b_id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }

}

data "aws_secretsmanager_secret_version" "db_credentials" {

  secret_id = aws_secretsmanager_secret.db_credentials.id

}

locals {

  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )

}

resource "aws_db_instance" "postgres" {

  identifier = "${var.project_name}-db"

  engine = "postgres"

  engine_version = "16"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  storage_type = "gp3"

  db_name = "projecthub"

  username = local.db_credentials.username

  password = local.db_credentials.password

  multi_az = true

  publicly_accessible = false

  storage_encrypted = true

  backup_retention_period = 7

  skip_final_snapshot = true

  deletion_protection = false

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.project_name}-db"
  }

}
