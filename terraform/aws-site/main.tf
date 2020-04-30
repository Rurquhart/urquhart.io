resource "aws_s3_bucket" "site-bucket" {
  bucket = var.bucket_name
  acl = "public-read"

  website {
    index_document = var.index_page
    error_document = var.error_page
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = var.cors_methods
    allowed_origins = var.cors_origins
    max_age_seconds = 3000
  }
}
