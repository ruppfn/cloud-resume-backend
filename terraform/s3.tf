data "aws_iam_policy_document" "bucket_policy" {
  policy_id = "${var.environment}-page-bucket"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      identifiers = [
        aws_cloudfront_origin_access_identity.web_oai.iam_arn
      ]
      type = "AWS"
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
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.page_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
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
