locals {
  vod_origin_legacy_id = "btv-legacy-origin-${var.env}"
}

resource "aws_cloudfront_distribution" "vod_distribution_legacy" {
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = var.legacy_cdn_domain
    origin_id           = local.vod_origin_legacy_id

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
  comment         = "BCCM VOD Leagcy Azure Backend"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket          = aws_s3_bucket.vod-logging-bucket.bucket_domain_name
    include_cookies = false
    prefix          = "vod-legacy-logs"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.vod_origin_legacy_id

    forwarded_values {
      query_string = false

      headers = []

      cookies {
        forward = "none"
      }
    }

    response_headers_policy_id = aws_cloudfront_response_headers_policy.simplecors.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  tags = {
    Environment = var.env
  }

  aliases = [
    var.custom_domain_legacy
  ]

  viewer_certificate {
    //cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.viewer_certificate_legacy.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  depends_on = [aws_s3_bucket.vod-logging-bucket]
}

data "aws_acm_certificate" "viewer_certificate_legacy" {
  domain   = var.custom_domain_legacy
  provider = aws.us_east_1
}
