resource "aws_iam_user_policy" "doe_user_policy" {
  name = "${local.project}-${local.environment}-policy"
  user = aws_iam_user.doe_user.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowOwnBucketList"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.doe_files.arn
      },
      {
        Sid    = "AllowOwnBucketObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.doe_files.arn}/*"
      },
      {
        Sid    = "AllowOwnEnvironmentParameters"
        Effect = "Allow"

        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]

        Resource = [
          "arn:aws:ssm:${var.aws_region}:*:parameter/DOE/COMMON/*",
          "arn:aws:ssm:${var.aws_region}:*:parameter/DOE/${upper(local.environment)}/*"
        ]
      }
    ]
  })
}