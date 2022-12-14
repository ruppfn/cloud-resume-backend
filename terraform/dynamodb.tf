resource "aws_dynamodb_table" "dynamo_table" {
  name           = "CloudResume"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  stream_enabled   = true
  stream_view_type = "KEYS_ONLY"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "dynamo_cv_item" {
  table_name = aws_dynamodb_table.dynamo_table.name
  hash_key   = aws_dynamodb_table.dynamo_table.hash_key
  item       = file("../cv-data.json")
}
