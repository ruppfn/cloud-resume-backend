resource "aws_iam_role" "rebuild_lambda_role" {
  name               = "${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "rebuild_lambda_cloudwatch_attachment" {
  policy_arn = aws_iam_policy.logs.arn
  role       = aws_iam_role.rebuild_lambda_role.name
}

data "aws_iam_policy_document" "allow_invalidation_document" {
  policy_id = "${var.environment}-lambda-invalidation"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["cloudfront:CreateInvalidation"]

    resources = [
      aws_cloudfront_distribution.page_distribution.arn,
    ]
  }
}

resource "aws_iam_policy" "allow_invalidation" {
  name   = "${var.environment}-cloudfront-lambda"
  policy = data.aws_iam_policy_document.allow_invalidation_document
}

resource "aws_iam_role_policy_attachment" "rebuild_lambda_invalidation_attachment" {
  policy_arn = aws_iam_policy.allow_invalidation.arn
  role       = aws_iam_role.rebuild_lambda_role.name
}
