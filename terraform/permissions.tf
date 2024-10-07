resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowViewCounterAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.view_counter_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_apigatewayv2_api.view_counter_api.execution_arn}/*"
}


data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


resource "aws_iam_policy" "view_counter_lambda_policy" {
  name = "AWSLambdaBasicExecutionRole-ViewCounterFunction"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:log-group:/aws/lambda/View_Counter_Function:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        "Resource" : "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:table/${data.aws_ssm_parameter.resume_table_name.value}"
      },
      {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      "Resource": [
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:parameter/*"
      ]
    }
    ]
  })
}

resource "aws_iam_role" "view_counter_lambda_role" {
  name = "view-counter-function-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = var.cloud_resume_tag
}

resource "aws_iam_role_policy_attachment" "view_counter_role_policy_attachment" {
  role       = aws_iam_role.view_counter_lambda_role.name
  policy_arn = aws_iam_policy.view_counter_lambda_policy.arn
}