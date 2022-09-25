data "aws_iam_policy_document" "bucket_policy" {
  policy_id = "${var.environment}-page-bucket"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.page_bucket.bucket}/*"
    ]
  }
}

resource "aws_s3_bucket" "page_bucket" {
  bucket = "www.${var.environment}-cloud-resume"
}

resource "aws_s3_bucket_policy" "page_policy" {
  bucket = aws_s3_bucket.page_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_acl" "page_acl" {
  bucket = aws_s3_bucket.page_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "page_configuration" {
  bucket = aws_s3_bucket.page_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}
