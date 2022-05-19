module "lambda_http_handler" {
  source                      = "./modules/lambda_http_handler"
  app_name                    = var.app_name
  environment_name            = var.environment_name
  handler_assembly            = var.dotnet_project_name
  handler_source_dir          = "${path.module}/../${var.dotnet_project_name}/bin/Debug/net6.0"
  primary_dynamodb_table_arn  = aws_dynamodb_table.primary_table.arn
  primary_dynamodb_table_name = aws_dynamodb_table.primary_table.name
}