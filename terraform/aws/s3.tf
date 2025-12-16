# S3 Bucket for application data
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-app-data-${var.environment}"

  tags = {
    Name        = "${var.project_name}-app-data"
    Environment = var.environment
  }
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket for Terraform state (optional)
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-terraform-state-${var.environment}"

  tags = {
    Name        = "${var.project_name}-terraform-state"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
