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

#region DynamoDB Seed Data

resource "aws_dynamodb_table_item" "seed_data" {
  table_name = aws_dynamodb_table.primary_table.name

  hash_key  = "pk"
  range_key = "sk"
  
  item = jsonencode({
    pk = {
      S = "PEOPLE"
    }

    sk = {
      S = "1"
    }

    firstName = {
      S = "DEMO_FIRST_NAME"
    }
  })
}

#endregion