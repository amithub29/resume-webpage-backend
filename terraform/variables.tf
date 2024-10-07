variable "cloud_resume_tag" {
  default = { Project = "Cloud Resume Challenge" }
}

variable "bucket_name_ssm_param" {
  default = "/resume_website/prod/s3/back_end/bucket_name"
}

variable "table_name_ssm_param" {
  default = "/resume_website/prod/dynamodb/table_name"
}