//Ingest bucket
//
resource "aws_s3_bucket" "vod-asset-ingest-bucket" {
  bucket = "vod-asset-ingest-${var.env}"

  tags = {
    Name        = "VOD asset ingest bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_acl" "vod-asset-ingest-bucket-acl" {
  bucket = aws_s3_bucket.vod-asset-ingest-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "expire-ingest" {
  bucket = aws_s3_bucket.vod-asset-ingest-bucket.id

  rule {
    id     = "Expire objects after 14 days"
    status = "Enabled"

    expiration {
      days = 14
    }
  }
}

output "s3-ingest-bucket-arn" {
  value = aws_s3_bucket.vod-asset-ingest-bucket.arn
}

// Asset Storage Bucket
//
resource "aws_s3_bucket" "vod-asset-storage-bucket" {
  bucket = "vod-asset-storage-${var.env}"

  tags = {
    Name        = "VOD asset storage bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_acl" "vod-asset-storage-bucket-acl" {
  bucket = aws_s3_bucket.vod-asset-storage-bucket.id
  acl    = "private"
}

output "s3-storage-bucket-arn" {
  value = aws_s3_bucket.vod-asset-storage-bucket.arn
}

data "aws_iam_policy_document" "allow_cloudfront" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.vod-asset-storage-bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [module.vod_cdn.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.vod-asset-storage-bucket.id
  policy = data.aws_iam_policy_document.allow_cloudfront.json
}

resource "aws_s3_bucket_cors_configuration" "allow-any-origin" {
  bucket = aws_s3_bucket.vod-asset-storage-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}
