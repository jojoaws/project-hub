resource "aws_s3_bucket" "frontend" {

  bucket = "${var.project_name}-frontend"

  tags = {
    Name = "${var.project_name}-frontend"
  }

}

resource "aws_s3_bucket_versioning" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket" "uploads" {

  bucket = "${var.project_name}-uploads"

  tags = {
    Name = "${var.project_name}-uploads"
  }

}

resource "aws_s3_bucket_versioning" "uploads" {

  bucket = aws_s3_bucket.uploads.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket_public_access_block" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  block_public_acls = true

  block_public_policy = true

  ignore_public_acls = true

  restrict_public_buckets = true

}

resource "aws_s3_bucket_public_access_block" "uploads" {

  bucket = aws_s3_bucket.uploads.id

  block_public_acls = true

  block_public_policy = true

  ignore_public_acls = true

  restrict_public_buckets = true

}

resource "aws_s3_bucket_lifecycle_configuration" "uploads" {

  bucket = aws_s3_bucket.uploads.id

  rule {

    id = "uploads-lifecycle"

    status = "Enabled"

    transition {

      days = 90

      storage_class = "STANDARD_IA"

    }

  }

}

resource "aws_iam_policy" "s3_access" {

  name = "${var.project_name}-s3-policy"

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

resource "aws_iam_role_policy_attachment" "task_s3_access" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.s3_access.arn

}
