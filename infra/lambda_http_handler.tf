#region IAM Policy

#resource "aws_iam_role_policy" "lambda_policy" {
#  name = "${var.app_name}.${var.environment_name}.lambda-policy"
#
#  role = aws_iam_role.lambda_exec.id
#
#  policy = jsonencode({
#    Version   = "2012-10-17",
#    Statement = [
#      {
#        Sid      = "Stmt1652579297004"
#        Action   = [
#          "dynamodb:Query",
#          "dynamodb:GetItem",
#        ],
#        Effect   = "Allow",
#        Resource = aws_dynamodb_table.primary_table.arn
#      }
#    ]
#  })
#}

data "archive_file" "http_handler" {
  output_path = "${path.module}/http_handler.zip"
  source_dir  = "${path.module}/../WebApplication1/bin/Debug/net6.0"
  type        = "zip"
}
#
#data "aws_iam_policy_document" "http_handler" {
#  version = "2012-10-17"
#
#  statement {
#    actions = [
#      "dynamodb:Query",
#      "dynamodb:GetItem",
#    ]
#
#    effect = "Allow",
#
#    resource = aws_dynamodb_table.primary_table.arn
#
#  }
#}
#
#resource "aws_iam_role" "http_handler" {
#  assume_role_policy = ""
#}
#
##endregion
#
##region Lambda Function
#
#resource "aws_lambda_function" "http_handler" {
#  function_name = ""
#  role          = aws_iam_role.http_handler.arn
#}
#
##endregion