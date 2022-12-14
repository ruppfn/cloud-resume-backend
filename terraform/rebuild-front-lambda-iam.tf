resource "aws_iam_role" "rebuild_lambda_role" {
  name               = "${var.environment}-rebuild-lambda-role"
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
  policy = data.aws_iam_policy_document.allow_invalidation_document.json
}

resource "aws_iam_role_policy_attachment" "rebuild_lambda_invalidation_attachment" {
  policy_arn = aws_iam_policy.allow_invalidation.arn
  role       = aws_iam_role.rebuild_lambda_role.name
}

data "aws_iam_policy_document" "allow_dynamo_stream" {
  policy_id = "${var.environment}-lambda-dynamo-stream"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams"
    ]
    resources = [
      aws_dynamodb_table.dynamo_table.arn,
      "${aws_dynamodb_table.dynamo_table.arn}/stream/*",
    ]
  }
}

resource "aws_iam_policy" "allow_read_dynamo_stream" {
  name   = "${var.environment}-allow-dynamo-stream"
  policy = data.aws_iam_policy_document.allow_dynamo_stream.json
}

resource "aws_iam_role_policy_attachment" "rebuild_lambda_stream_attachment" {
  policy_arn = aws_iam_policy.allow_read_dynamo_stream.arn
  role       = aws_iam_role.rebuild_lambda_role.name
}

data "aws_iam_policy_document" "allow_ssm" {
  policy_id = "${var.environment}-lambda-ssm"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      aws_ssm_parameter.github_pat.arn,
      "${aws_ssm_parameter.github_pat.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "allow_ssm_policy" {
  name   = "${var.environment}-allow-ssm"
  policy = data.aws_iam_policy_document.allow_ssm.json
}

resource "aws_iam_role_policy_attachment" "rebuild_lambda_ssm_attachment" {
  policy_arn = aws_iam_policy.allow_ssm_policy.arn
  role       = aws_iam_role.rebuild_lambda_role.name
}

data "aws_iam_policy_document" "allow_ssm_decrypt" {
  policy_id = "${var.environment}-lambda-ssm-decrypt"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "arn:aws:kms:${local.region}:${local.account_id}:${aws_ssm_parameter.github_pat.key_id}"
    ]
  }
}

resource "aws_iam_policy" "allow_ssm_decrypt_policy" {
  name   = "${var.environment}-allow-ssm-decrypt"
  policy = data.aws_iam_policy_document.allow_ssm_decrypt.json
}

resource "aws_iam_role_policy_attachment" "rebuild_lambda_ssm_decrypt_attachment" {
  policy_arn = aws_iam_policy.allow_ssm_decrypt_policy.arn
  role       = aws_iam_role.rebuild_lambda_role.name
}
