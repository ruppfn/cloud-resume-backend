data "aws_iam_policy_document" "lambda-logs" {
  policy_id = "${var.environment}-lambda-logs"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/${var.environment}*:*"
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name   = "${var.environment}-lambda-logs"
  policy = data.aws_iam_policy_document.lambda-logs.json
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
