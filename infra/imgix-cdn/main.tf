terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0"
      configuration_aliases = [aws.main, aws.us_east_1]
    }
  }
}

variable "backend-domain" {
  type = string
}

variable "frontend-domain" {
  type = string
}

resource "aws_cloudfront_cache_policy" "imgix" {
  name        = "imgix"
  default_ttl = 31536000
  min_ttl     = 6000
  max_ttl     = 31536000

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "all"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}


resource "aws_cloudfront_distribution" "imgix-cdn" {
  provider = aws.main
  count    = aws_acm_certificate.imgix-cdn.status == "PENDING_VALIDATION" ? 0 : 1
  origin {
    origin_id   = "imgix-cdn"
    domain_name = var.backend-domain
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "imgxix-cdn"
  aliases         = [var.frontend-domain]

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.imgix-cdn.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    cache_policy_id        = aws_cloudfront_cache_policy.imgix.id
    target_origin_id       = "imgix-cdn"
    viewer_protocol_policy = "redirect-to-https"
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    compress               = true
  }
}


resource "aws_acm_certificate" "imgix-cdn" {
  provider          = aws.us_east_1
  domain_name       = var.frontend-domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

output "validation-options" {
  value = aws_acm_certificate.imgix-cdn.domain_validation_options
}
