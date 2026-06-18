resource "random_password" "db_password" {

  length = 32

  special = true

}

resource "aws_secretsmanager_secret" "db_credentials" {

  name = "${var.project_name}-db-credentials"

  description = "Database credentials for ProjectHub"

}

resource "aws_secretsmanager_secret_version" "db_credentials" {

  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({

    username = "projecthub_admin"

    password = random_password.db_password.result

  })

}
