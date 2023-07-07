
resource "aws_cloudfront_distribution" "manifests" {
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
  comment         = "BCCM VOD - Raw manifest cache"

  aliases = []

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = local.vod_origin_id
    viewer_protocol_policy = "allow-all"
    trusted_key_groups     = [aws_cloudfront_key_group.vod.id]
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cache_policy_id = "08627262-05a9-4f76-9ded-b50ca2e3a84f" // Managed mediapackage Cache Policy
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress                   = true
    default_ttl                = 0
    max_ttl                    = 0
    min_ttl                    = 0
    path_pattern               = "*.m3u8"
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"
    smooth_streaming           = false
    target_origin_id           = local.vod_origin_id
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "allow-all"
  }

  price_class = "PriceClass_200"

  tags = {
    Environment = var.env
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "manifest-cdn-domain" {
  value = aws_cloudfront_distribution.manifests.domain_name
}
