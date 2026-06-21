resource "random_password" "db_password" {

  length = 32

  special = true

  override_special = "!#$%^&*()-_=+[]{}"

}

resource "random_password" "jwt_secret" {

  length = 64

  special = false

}


resource "aws_secretsmanager_secret" "app_secrets" {

  name = "${var.project_name}-app-secrets"

  description = "Application runtime secrets for ProjectHub"

}

resource "aws_secretsmanager_secret_version" "app_secrets" {

  secret_id = aws_secretsmanager_secret.app_secrets.id

  secret_string = jsonencode({

    JWT_SECRET_KEY = random_password.jwt_secret.result

    DATABASE_URL = "postgresql+psycopg2://projecthub_admin:${random_password.db_password.result}@${aws_db_instance.postgres.address}:5432/projecthub"

  })

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

resource "aws_secretsmanager_secret" "jwt_secret" {

  name = "${var.project_name}-jwt-secret"

  description = "JWT secret for ProjectHub"

}

resource "aws_secretsmanager_secret_version" "jwt_secret" {

  secret_id = aws_secretsmanager_secret.jwt_secret.id

  secret_string = random_password.jwt_secret.result

}

resource "aws_iam_policy" "secrets_access" {

  name = "${var.project_name}-secrets-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [

          aws_secretsmanager_secret.db_credentials.arn,

          aws_secretsmanager_secret.jwt_secret.arn,

          aws_secretsmanager_secret.app_secrets.arn

        ]

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "execution_secrets_access" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = aws_iam_policy.secrets_access.arn

}
