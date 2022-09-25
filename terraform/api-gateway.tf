resource "aws_apigatewayv2_api" "http-api" {
  name          = "${var.environment}-cloud-resume"
  description   = "API Gateway HTTP for cloud-resume."
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "cv_lambda_integration" {
  api_id           = aws_apigatewayv2_api.http-api.id
  integration_uri  = aws_lambda_function.cv_lambda.invoke_arn
  integration_type = "AWS_PROXY"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.http-api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.cv_lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.http-api.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.log.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  depends_on = [aws_cloudwatch_log_group.log]
}
