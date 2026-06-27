resource "aws_iam_role" "lambda_role" {

  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "lambda.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_iam_policy" "lambda_s3_policy" {

  name = "${var.project_name}-lambda-s3-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "s3:GetObject",

          "s3:PutObject"

        ]

        Resource = [

          "${aws_s3_bucket.uploads.arn}/*"

        ]

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "lambda_s3_attachment" {

  role = aws_iam_role.lambda_role.name

  policy_arn = aws_iam_policy.lambda_s3_policy.arn

}

resource "aws_lambda_function" "thumbnail_generator" {

  function_name = "${var.project_name}-thumbnail-generator"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"

  handler = "lambda_function.lambda_handler"

  filename = "../lambda/function.zip"

  source_code_hash = filebase64sha256("../lambda/function.zip")

  timeout = 30

  environment {

    variables = {

      BUCKET_NAME = aws_s3_bucket.uploads.bucket

      DB_SECRET_ARN = aws_secretsmanager_secret.db_credentials.arn

      SES_SENDER_EMAIL = var.sender_email
    }

  }

}

resource "aws_s3_bucket_notification" "uploads" {

  bucket = aws_s3_bucket.uploads.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.thumbnail_generator.arn

    events = [

      "s3:ObjectCreated:*"

    ]

  }

}

resource "aws_lambda_permission" "allow_s3" {

  statement_id = "AllowExecutionFromS3"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.thumbnail_generator.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.uploads.arn

}

resource "aws_iam_policy" "lambda_secrets_policy" {

  name = "${var.project_name}-lambda-secrets-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.db_credentials.arn

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "lambda_secrets_attachment" {

  role = aws_iam_role.lambda_role.name

  policy_arn = aws_iam_policy.lambda_secrets_policy.arn

}
