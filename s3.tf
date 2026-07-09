resource "aws_s3_bucket" "doe_files" {
  bucket = local.bucket_name

  tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "doe_files_versioning" {
  bucket = aws_s3_bucket.doe_files.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "doe_files_block" {
  bucket = aws_s3_bucket.doe_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}