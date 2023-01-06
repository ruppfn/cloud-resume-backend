resource "aws_ssm_parameter" "github_pat" {
  name      = "/${var.environment}/cloud-resume/github-pat"
  type      = "SecureString"
  value     = "This is the real value... Trust me, im a dolphin"
  overwrite = false
}
