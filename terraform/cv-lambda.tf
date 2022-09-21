data "archive_file" "cv_lambda_zip" {
  type        = "zip"
  source_file = "${local.build_path}/cv-lambda"
  output_path = "${local.build_path}/cv-lambda.zip"
}

resource "aws_lambda_function" "func" {
  filename         = data.archive_file.cv_lambda_zip.output_path
  function_name    = "cv-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main"
  source_code_hash = filebase64sha256(data.archive_file.cv_lambda_zip.output_path)
  runtime          = "go1.x"
  memory_size      = 128
  timeout          = 30
}
