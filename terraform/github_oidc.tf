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
          "iam:PassRole",
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:GetOpenIDConnectProvider",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies"

        ]

        Resource = [

          aws_iam_role.ecs_task_role.arn,

          aws_iam_role.ecs_execution_role.arn

        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          "arn:aws:s3:::${var.terraform_state_bucket}"
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "arn:aws:s3:::${var.terraform_state_bucket}/*"
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetBucketVersioning",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetLifecycleConfiguration",
          "s3:GetBucketPolicy",
          "s3:GetBucketWebsite",
          "s3:GetBucketTagging",
          "s3:GetBucketEncryption"

        ]

        Resource = [
          "arn:aws:s3:::${var.terraform_state_bucket}"
        ]
      },

      {

        Effect = "Allow"

        Action = [

          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages"

        ]

        Resource = "*"

      },

      {

        Effect = "Allow"

        Action = [

          "ec2:DescribeImages",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeRouteTables",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeNatGateways",
          "ec2:DescribeAddresses",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeAvailabilityZones"

        ]

        Resource = "*"

      },

      {

        Effect = "Allow"

        Action = [

          "cloudfront:ListOriginRequestPolicies",
          "cloudfront:ListCachePolicies",
          "cloudfront:GetOriginAccessControl",
          "cloudfront:DescribeFunction",
          "cloudfront:GetDistribution",
          "cloudfront:GetDistributionConfig",
          "cloudfront:GetFunction"

        ]

        Resource = "*"

      },

      {
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"

        ],

        "Resource" : "*"
      },

      {
        "Effect" : "Allow",
        "Action" : [
          "sns:GetTopicAttributes",
          "sns:ListSubscriptionsByTopic"

        ],

        "Resource" : "*"
      },

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ses:GetIdentityVerificationAttributes"
        ]

        Resource = "*"
      },

      {

        Effect = "Allow"

        Action = [

          "ecs:DescribeClusters",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTaskSets",
          "ecs:ListServices",
          "ecs:ListTaskDefinitions",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"

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
