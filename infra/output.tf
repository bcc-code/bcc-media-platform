output "mediapackage_cdn_auth_secret_arn" {
  value = module.vod_cdn.mediapackage_cdn_auth_secret_arn
}

output "mediapackage_cdn_auth_role_arn" {
  value = module.vod_cdn.mediapackage_cdn_auth_role_arn
}

output "imgix_ssl_validation_domain" {
  value = module.imgx_cdn
}

