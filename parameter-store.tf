locals {
  parameters = csvdecode(file("${path.module}/parameters.csv"))
}

resource "aws_ssm_parameter" "secrets" {
  for_each = {
    for parameter in local.parameters : parameter.key => parameter
  }

  name      = each.value.key
  type      = "SecureString"
  value     = each.value.value
  overwrite = true

  tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}