output "http_api_base_url" {
  value = aws_apigatewayv2_stage.http_api_default.invoke_url
}