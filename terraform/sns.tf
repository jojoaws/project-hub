resource "aws_sns_topic" "notifications" {

  name = "${var.project_name}-notifications"

}

resource "aws_iam_policy" "ecs_sns_policy" {

  name = "${var.project_name}-sns-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "sns:Publish"

        ]

        Resource = aws_sns_topic.notifications.arn

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "ecs_sns_attachment" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.ecs_sns_policy.arn

}

resource "aws_iam_policy" "sns_publish" {

  name = "${var.project_name}-sns-publish-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "sns:Publish"

        ]

        Resource = aws_sns_topic.notifications.arn

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "task_sns_publish" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.sns_publish.arn

}
