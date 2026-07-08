locals {

  project = "doe"

  environment = terraform.workspace

  user_name = "doe-${local.environment}"

  bucket_name = "doe-${local.environment}-files"

  parameter_prefix = "/doe/${local.environment}"

}