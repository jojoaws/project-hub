resource "aws_iam_openid_connect_provider" "github" {

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

}

resource "aws_iam_role" "github_actions" {

  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {

          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:jojoaws/project-hub:*"
          }

        }

      }

    ]

  })

}

resource "aws_iam_policy" "github_actions" {

  name = "${var.project_name}-github-actions-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = [
          aws_iam_role.ecs_task_role.arn,
          aws_iam_role.ecs_execution_role.arn,
          aws_iam_role.lambda_role.arn,
          aws_iam_role.notification_lambda_role.arn
        ]
      },

      {
        Effect = "Allow"

        Action = [

          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "application-autoscaling:*",

          "ecs:*",
          "ecr:*",

          "s3:*",

          "cloudfront:*",

          "cloudwatch:*",

          "logs:*",

          "lambda:*",

          "sns:*",

          "rds:*",

          "ses:*",

          "secretsmanager:*",

          "iam:Get*",
          "iam:List*",

        ]

        Resource = "*"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "github_actions" {

  role = aws_iam_role.github_actions.name

  policy_arn = aws_iam_policy.github_actions.arn

}
