resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_route53_record" "api_record" {
  name    = local.domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_apigatewayv2_domain_name.domain_name.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name.domain_name_configuration[0].hosted_zone_id
  }
}

resource "aws_apigatewayv2_domain_name" "domain_name" {
  domain_name = local.domain_name
  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.validation.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.validation]
}

resource "aws_apigatewayv2_api_mapping" "mapping" {
  api_id      = aws_apigatewayv2_api.http-api.id
  domain_name = aws_apigatewayv2_domain_name.domain_name.id
  stage       = aws_apigatewayv2_stage.default.id
}
