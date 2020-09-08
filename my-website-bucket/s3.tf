provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

variable "name" {
  type = string
}

variable "html_file_source" {
  type = string
}

resource "aws_s3_bucket" "website_bucket" {
  bucket =  var.name
  acl    = "public-read"

  force_destroy = true

  website {
    index_document = var.html_file_source
    error_document = var.html_file_source
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Public-Access",
  "Statement": [
    {
      "Sid": "Allow-Public-Access-To-Bucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = var.html_file_source
  source = var.html_file_source
  content_type = "text/html"
}

output "website_endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}
