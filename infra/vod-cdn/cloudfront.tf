locals {
  vod_origin_id   = "btv-vod-origin-${var.env}"
  fiels_origin_id = "btv-files-origin-${var.env}"
}

resource "aws_s3_bucket" "vod-logging-bucket" {
  bucket = "vod-cloudfront-logging-${var.env}"

  tags = {
    Name        = "VOD logging bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_acl" "vod-logging-bucket-acl" {
  bucket = aws_s3_bucket.vod-logging-bucket.id
  acl    = "private"
}

output "s3-logging-bucket-arn" {
  value = aws_s3_bucket.vod-logging-bucket.arn
}

resource "aws_cloudfront_distribution" "vod_distribution" {
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = var.mediapackage_url
    origin_id           = local.vod_origin_id
    custom_header {
      name  = "X-MediaPackage-CDNIdentifier"
      value = random_uuid.cdn_auth_secret.result
    }
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "BCCM VOD"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket          = aws_s3_bucket.vod-logging-bucket.bucket_domain_name
    include_cookies = false
    prefix          = "vod2-logs"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.vod_origin_id

    forwarded_values {
      query_string = false

      headers = []

      cookies {
        forward = "none"
      }
    }


    response_headers_policy_id = aws_cloudfront_response_headers_policy.simplecors.id

    trusted_key_groups = [aws_cloudfront_key_group.vod.id]

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" // Caching disabled
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress                   = true
    default_ttl                = 0
    max_ttl                    = 0
    min_ttl                    = 0
    path_pattern               = "*.m3u8"
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.manifest_lambda.id
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"
    smooth_streaming           = false
    target_origin_id           = local.vod_origin_id
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "allow-all"
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = module.manifest_lambda.arn
      include_body = false
    }
  }

  price_class = "PriceClass_All"

  tags = {
    Environment = var.env
  }

  aliases = [
    var.custom_domain
  ]

  viewer_certificate {
    //cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.viewer_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  depends_on = [aws_s3_bucket.vod-logging-bucket]
}

resource "aws_cloudfront_response_headers_policy" "simplecors" {
  name    = "Custom-SimpleCORS-${var.env}"
  comment = "Used for basic cors without credentials"

  cors_config {
    access_control_max_age_sec       = 600
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["ALL"]
    }

    access_control_allow_origins {
      items = ["*"]
    }

    origin_override = true
  }
}

data "aws_acm_certificate" "viewer_certificate" {
  domain   = var.custom_domain
  provider = aws.us_east_1
}

resource "aws_cloudfront_public_key" "vod" {
  for_each    = var.public_keys
  comment     = "For VOD distribution"
  encoded_key = each.value
  name        = "vod_${each.key}_${var.env}"
}

resource "aws_cloudfront_key_group" "vod" {
  comment = "For VOD distribution"
  items   = [for s in aws_cloudfront_public_key.vod : s.id]
  name    = "vod-${var.env}"
}
