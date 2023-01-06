resource "aws_cloudwatch_log_group" "log" {
  name              = "/aws/${var.environment}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "cv_lambda_group" {
  name              = "/aws/lambda/${aws_lambda_function.cv_lambda.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "rebuild_lambda_group" {
  name              = "/aws/lambda/${aws_lambda_function.rebuild_front_lambda.function_name}"
  retention_in_days = 7
}
