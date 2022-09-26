locals {
  web_domain_name = "cv.${local.base_domain_name}"
}

resource "aws_cloudfront_distribution" "page_distribution" {
  enabled             = true
  price_class         = "PriceClass_All"
  default_root_object = "index.html"

  aliases = [local.web_domain_name]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.page_bucket.bucket}"
    # Forward all query strings, cookies and headers
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  origin {
    domain_name = aws_s3_bucket_website_configuration.page_configuration.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.page_bucket.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web_oai.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  # If there is a 404, return index.html with a HTTP 200 Response
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  depends_on = [aws_acm_certificate_validation.cloudfront_validation]
}

resource "aws_cloudfront_origin_access_identity" "web_oai" {
  comment = "OAI for ${local.web_domain_name}"
}
