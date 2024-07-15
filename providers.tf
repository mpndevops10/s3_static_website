provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "mpn-statefiles"
    key            = "s3-static-website/dev/terraform.tfstate" # The name of the terraform state file in S3 bucket
    dynamodb_table = "mpn-state-lock"
    encrypt        = true
    region         = "us-east-1"
  }
}