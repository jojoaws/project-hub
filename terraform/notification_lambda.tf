resource "aws_iam_role" "notification_lambda_role" {

  name = "${var.project_name}-notification-lambda-role"

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

resource "aws_iam_role_policy_attachment" "notification_lambda_basic" {

  role = aws_iam_role.notification_lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_iam_policy" "notification_lambda_ses_policy" {

  name = "${var.project_name}-notification-ses-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "ses:SendEmail",

          "ses:SendRawEmail"

        ]

        Resource = "*"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "notification_lambda_ses_attachment" {

  role = aws_iam_role.notification_lambda_role.name

  policy_arn = aws_iam_policy.notification_lambda_ses_policy.arn

}

resource "aws_lambda_function" "notification" {

  function_name = "${var.project_name}-notification"

  role = aws_iam_role.notification_lambda_role.arn

  runtime = "python3.12"

  handler = "lambda_function.lambda_handler"

  filename = "../lambda/notification.zip"

  source_code_hash = filebase64sha256("../lambda/notification.zip")

  timeout = 30

}

resource "aws_sns_topic_subscription" "notification_lambda" {

  topic_arn = aws_sns_topic.notifications.arn

  protocol = "lambda"

  endpoint = aws_lambda_function.notification.arn

}

resource "aws_lambda_permission" "allow_sns" {

  statement_id = "AllowExecutionFromSNS"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.notification.function_name

  principal = "sns.amazonaws.com"

  source_arn = aws_sns_topic.notifications.arn

}
