resource "aws_cloudfront_origin_access_identity" "s3_files" {
  comment = "For downloaing muxed videos"
}

output "origin_access_identity" {
  value = aws_cloudfront_origin_access_identity.s3_files
}

resource "aws_cloudfront_distribution" "vod_files" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "BCCM VOD FIles"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket          = aws_s3_bucket.vod-logging-bucket.bucket_domain_name
    include_cookies = false
    prefix          = "vod2-files-logs"
  }

  default_cache_behavior {

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" // Default cache policy
    cached_methods = [
      "GET",
      "HEAD",
    ]
    response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c" // SimpleCORS managed policy

    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "s3_files"
    trusted_key_groups     = [aws_cloudfront_key_group.vod.id]
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  tags = {
    Environment = var.env
  }

  aliases = [
    var.files_custom_domain
  ]

  viewer_certificate {
    //cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.files_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  origin {
    domain_name = var.download_s3_domain
    origin_id   = "s3_files"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_files.cloudfront_access_identity_path
    }
  }

  depends_on = [aws_s3_bucket.vod-logging-bucket]
}

data "aws_acm_certificate" "files_certificate" {
  domain   = var.files_custom_domain
  provider = aws.us_east_1
}
