variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
    error_message = "Bucket Name must not be empty and must follow S3 naming rules."
  }
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}