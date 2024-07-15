variable "aws_region" {
  description = "aws region to create the instance"
  type        = string
  default     = "us-east-2"
}

variable "s3_bucket" {
  description = "S3 AWS bucket name"
  type        = string
  default     = "us-east-1"
}