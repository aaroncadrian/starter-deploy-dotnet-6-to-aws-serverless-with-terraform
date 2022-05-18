#region API Gateway

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.app_name}.${var.environment_name}.http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "http_api_default" {
  api_id = aws_apigatewayv2_api.http_api.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.http_api.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

resource "aws_cloudwatch_log_group" "http_api" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.http_api.name}"

  retention_in_days = 30
}

#endregion

#region API Gateway Route/Integration

resource "aws_apigatewayv2_integration" "svc_function" {
  api_id = aws_apigatewayv2_api.http_api.id

  integration_uri    = aws_lambda_function.http_handler.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "svc_function" {
  api_id = aws_apigatewayv2_api.http_api.id

  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.svc_function.id}"
}

resource "aws_lambda_permission" "api_gw_svc_function" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http_handler.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

#endregion