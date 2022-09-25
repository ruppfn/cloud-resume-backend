resource "aws_cloudwatch_log_group" "log" {
  name              = "/aws/${var.environment}"
  retention_in_days = 7
}
