#region IAM for Lambda

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.app_name}.${var.environment_name}.lambda-policy"

  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid      = "Stmt1652579297004"
        Action   = [
          "dynamodb:Query",
          "dynamodb:GetItem",
        ],
        Effect   = "Allow",
        Resource = var.primary_dynamodb_table_arn
      }
    ]
  })
}


resource "aws_iam_role" "lambda_exec" {
  name = "${var.app_name}.${var.environment_name}.lambda-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#endregion

#region Lambda Function

data "archive_file" "http_handler" {
  output_path = "${path.module}/http_handler.zip"
  source_dir  = var.handler_source_dir
  type        = "zip"
}

resource "aws_lambda_function" "http_handler" {
  function_name = "${var.app_name}_${var.environment_name}"

  handler          = var.handler_assembly
  filename         = data.archive_file.http_handler.output_path
  source_code_hash = data.archive_file.http_handler.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  timeout = 10

  runtime = "dotnet6"

  environment {
    variables = {
      PRIMARY_DYNAMO_TABLE_NAME = var.primary_dynamodb_table_name
    }
  }
}

#endregion