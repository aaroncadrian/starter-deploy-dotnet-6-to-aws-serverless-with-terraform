#region DynamoDB

resource "aws_dynamodb_table" "primary_table" {
  hash_key  = "pk"
  range_key = "sk"

  name = "${var.app_name}.${var.environment_name}"

  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }
}

#endregion
