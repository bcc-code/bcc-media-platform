
resource "aws_cloudfront_cache_policy" "raw_manifests" {
  name        = "raw_manifests-${var.env}"
  comment     = ""
  default_ttl = 31536000
  max_ttl     = 31536000
  min_ttl     = 31536000
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["aws.manifestfilter", "end", "m", "start"]
      }
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "manifest_lambda" {
  name    = "manifest_lambda_${var.env}"
  comment = "The origin requests goes to lambda@edge for manifest requests, and these are the settings for that origin request."

  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "allViewer"
  }

  query_strings_config {
    query_string_behavior = "whitelist"
    query_strings {
      items = ["EncodedPolicy", "m", "aws.manifestfilter"]
    }
  }

}
