provider "aws" {
  version = "~> 2.8"
  region  = "eu-west-1"
}

terraform {
  required_version = "0.12.21" # Version available on GitHub Action runners

  backend "s3" {
    bucket         = "rurq-tf-state"
    region         = "eu-west-1"
    key            = "urquhart-io/terraform.tfstate"
    dynamodb_table = "rurq-tf-locks"
  }
}

resource "aws_s3_bucket" "site-bucket" {
  bucket = "urquhart.io"
  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "redirect-bucket" {
  bucket = "www.urquhart.io"

  website {
    redirect_all_requests_to = "urquhart.io"
  }
}
