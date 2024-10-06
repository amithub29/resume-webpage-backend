resource "aws_apigatewayv2_api" "view_counter_api" {
  name          = "View_Counter_API"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET"]
    max_age = 3000
  }
  tags = var.cloud_resume_tag
}

resource "aws_apigatewayv2_integration" "resume_backend_function" {
  api_id           = aws_apigatewayv2_api.view_counter_api.id
  integration_type = "AWS_PROXY"
  connection_type           = "INTERNET"
  integration_method        = "POST"
  integration_uri           = "arn:aws:lambda:us-east-1:891377355669:function:resume_backend"
  payload_format_version    = "2.0"
}

resource "aws_apigatewayv2_route" "get_default" {
  api_id    = aws_apigatewayv2_api.view_counter_api.id
  route_key = "GET /"
  target = "integrations/${aws_apigatewayv2_integration.resume_backend_function.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.view_counter_api.id
  name   = "$default"
  auto_deploy = true
}