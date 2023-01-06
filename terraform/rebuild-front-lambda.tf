data "archive_file" "rebuild_front_lambda_zip" {
  type        = "zip"
  source_file = "${local.build_path}/rebuild-front-lambda/bootstrap"
  output_path = "${local.build_path}/rebuild-front-lambda/bootstrap.zip"
}

resource "aws_lambda_function" "rebuild_front_lambda" {
  filename         = data.archive_file.rebuild_front_lambda_zip.output_path
  function_name    = "rebuild-front-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "rebuild-front-lambda"
  source_code_hash = filebase64sha256(data.archive_file.rebuild_front_lambda_zip.output_path)
  runtime          = "provided.al2"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
      REGION          = local.region
      PARAMETER_NAME  = aws_ssm_parameter.github_pat.name
      DISTRIBUTION_ID = aws_cloudfront_distribution.page_distribution.id
      POST_URL        = "https://api.github.com/repos/ruppfn/cloud-resume-frontend/dispatches"
    }
  }
}
