resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowViewCounterAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "resume_backend"
  principal     = "apigateway.amazonaws.com"
  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_apigatewayv2_api.view_counter_api.execution_arn}/*"
}