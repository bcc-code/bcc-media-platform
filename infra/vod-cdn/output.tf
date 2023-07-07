

output "mediapackage_cdn_auth_secret_arn" {
  value = aws_secretsmanager_secret.cdn_auth.arn
}

output "mediapackage_cdn_auth_role_arn" {
  value = aws_iam_role.cdn_auth.arn
}

output "vod-cdn-domain" {
  value = aws_cloudfront_distribution.vod_distribution.domain_name
}

output "keypairs" {
  value = values(aws_cloudfront_public_key.vod)[*].id
}
