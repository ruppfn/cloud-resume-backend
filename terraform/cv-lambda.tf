data "archive_file" "cv_lambda_zip" {
  type        = "zip"
  source_file = "${local.build_path}/cv-lambda/bootstrap"
  output_path = "${local.build_path}/cv-lambda/bootstrap.zip"
}

resource "aws_lambda_function" "cv_lambda" {
  filename         = data.archive_file.cv_lambda_zip.output_path
  function_name    = "cv-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "cv-lambda"
  source_code_hash = filebase64sha256(data.archive_file.cv_lambda_zip.output_path)
  runtime          = "provided.al2"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
      REGION     = local.region
      TABLE_NAME = aws_dynamodb_table.dynamo_table.name
      KEY        = aws_dynamodb_table.dynamo_table.hash_key
      VALUE      = "cv"
    }
  }
}
