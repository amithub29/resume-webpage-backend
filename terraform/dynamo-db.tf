data "aws_ssm_parameter" "resume_table_name" {
  name = var.table_name_ssm_param
}

resource "aws_dynamodb_table" "resume_table" {
  name           = data.aws_ssm_parameter.resume_table_name.value
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "p_key"

  attribute {
    name = "p_key"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.cloud_resume_tag
}