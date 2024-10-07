data "aws_ssm_parameter" "resume_bucket_name" {
  name = var.bucket_name_ssm_param
}

resource "aws_lambda_function" "view_counter_lambda_function" {
  function_name = "view_counter_function"
  role          = aws_iam_role.view_counter_lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  s3_bucket     = data.aws_ssm_parameter.resume_bucket_name.value
  s3_key        = "backend/lambda_function_payload.zip"
  runtime       = "python3.10"
  tags          = var.cloud_resume_tag
  timeout       = 10
}