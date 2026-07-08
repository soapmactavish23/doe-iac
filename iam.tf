resource "aws_iam_user" "doe_user" {

  name = local.user_name

  tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }

}