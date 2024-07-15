output "s3-endpoint" {
  description = "s3 endpoint to access the website"
  value       = join("", ["http://", aws_s3_bucket_website_configuration.website-config.website_endpoint])
  # value       = join("", ["http://", aws_s3_bucket.s3.website_endpoint]) // the attribute "website_endpoint" is depreciated
}