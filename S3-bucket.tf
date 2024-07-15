## 1. Create an s3 bucket
resource "aws_s3_bucket" "s3" {
  bucket = var.s3_bucket
}

## 2. Grant public read access to our S3 bucket content
# a) Configure s3 bucket acl to publicly read-only
resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket     = aws_s3_bucket.s3.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.s3-pub-access]
}

# b) Manages S3 bucket-level Public Access Block configuration
resource "aws_s3_bucket_public_access_block" "s3-pub-access" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# c) Configure S3 bucket policy
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket}/*"
        ]
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.s3-pub-access]
}

## 3. Enable s3 bucket versioning
resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

## 4. Configure index and error html document
resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.s3.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

## 5. Upload our website files to the S3 bucket and grant read-only access
resource "aws_s3_object" "upload-files" {
  bucket = aws_s3_bucket.s3.id

  for_each     = fileset("./uploads/", "**/*.*")
  key          = each.value
  source       = "./uploads/${each.value}"
  content_type = each.value
  acl          = "public-read"

}