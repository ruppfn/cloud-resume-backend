data "aws_iam_policy_document" "lambda-logs" {
  policy_id = "${var.environment}-lambda-logs"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:CreateLogGroup"]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/*:*"
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name   = "${var.environment}-lambda-logs"
  policy = data.aws_iam_policy_document.lambda-logs.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_cloudwatch" {
  policy_arn = aws_iam_policy.logs.arn
  role       = aws_iam_role.lambda_role.name
}

data "aws_iam_policy_document" "lambda-dynamodb" {
  policy_id = "${var.environment}-lambda-dynamodb"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["dynamodb:GetItem"]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/${aws_dynamodb_table.dynamo_table.name}"
    ]
  }
}

resource "aws_iam_policy" "dynamodb" {
  name   = "${var.environment}-lambda-dynamodb"
  policy = data.aws_iam_policy_document.lambda-dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_dynamo" {
  policy_arn = aws_iam_policy.dynamodb.arn
  role       = aws_iam_role.lambda_role.name
}

data "aws_iam_policy_document" "lambda_assume_role" {
  policy_id = "${var.environment}-lambda"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cv_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http-api.execution_arn}/*/*"
}
