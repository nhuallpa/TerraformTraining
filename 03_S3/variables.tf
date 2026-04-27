variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
  default     = "example-bucket-terraform-2024"
}

variable "region" {
  description = "The AWS region where the S3 bucket will be created."
  type        = string
  default     = "us-east-1"
}