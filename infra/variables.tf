variable "env" {
  type = string
}

variable "basepath" {
  type = string
}

variable "gcp-region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "tag" {
  type = string
}

variable "branch" {
  type = string
}

variable "mediapackage_url" {
  type = string
}

variable "vod_cdn_public_keys" {
  type = map(string)
}

variable "vod_cloudfront_domain" {
  type = string
}

variable "background_worker_secrets" {
  type = map(any)
}

variable "background_worker_secret_files" {
  type = map(any)
}

variable "background_worker_env" {
  type = map(any)
}

variable "api_secrets" {
  type = map(any)
}

variable "api_secret_files" {
  type = map(any)
}

variable "api_env" {
  type = map(any)
}

variable "directus_secrets" {
  type = map(any)
}

variable "directus_env" {
  type = map(any)
}

variable "rewriter_secrets" {
  type = map(any)
}

variable "rewriter_env" {
  type = map(any)
}

variable "stream_proxy_secrets" {
  type = map(any)
}

variable "stream_proxy_env" {
  type = map(any)
}

variable "db" {
  type = map(any)
}

variable "db-tier" {
  type = string
}

variable "views_refresh_schedule" {
  type = string
}

variable "search_reindex_schedule" {
  type = string
}

variable "translations_sync_schedule" {
  type = string
}

variable "answers_sync_schedule" {
  type = string
}

variable "shorts_scores_sync_schedule" {
  type = string
}

variable "base_platform_domain" {
  type = string
}

variable "web_domains" {
  type = list(string)
}

variable "legacy_cdn_domain" {
  type = string
}

variable "redis_enable" {
  type = bool
}

variable "redis_address" {
  type = string
}

variable "redis_username" {
  type = string
}

variable "redis_database" {
  type = string
}

variable "additional_cert_path" {
  type = string
}

variable "additional_key_path" {
  type = string
}

variable "monitoring_enabled" {
  type = bool
}

variable "npaw_account_code" {
  type = string
}

variable "rudderstack_data_plane_url" {
  type = string
}

variable "rudderstack_write_key" {
  type = string
}

variable "unleash_url" {
  type = string
}

variable "unleash_api_token" {
  type = string
}

variable "unleash_proxy_client_key" {
  type = string
}

variable "imgix_cdn_enable" {
  type = bool
}

variable "imgix_backend_domain" {
  type = string
}

variable "imgix_frontend_domain" {
  type = string
}

variable "semaphore_service_account" {
  type = string
}


variable "admin_web_domains" {
  type        = list(string)
  description = "Domains for the admin-web static site (empty = no cert/LB routing in this env)"
  default     = []
}

variable "admin_cors_origins" {
  type        = string
  description = "Comma-separated origin allowlist for the admin auth/GraphQL endpoints (admin-web origins). Must be same-site with the API host admin-web uses (api.bcc.media) for the refresh cookie to work."
  default     = "https://admin.app.bcc.media"
}

variable "live_cdn" {
  type = object({
    hostname    = string # e.g. live-cdn.bcc.media — becomes STREAM_PROXY_LIVE_CDN_DOMAIN_IORIVER
    origin_host = string # live MediaPackage endpoint host
  })
  description = "Live ioriver vCDN config; null disables all live-cdn resources (dev/sta)."
  default     = null
}

variable "ioriver_live_token" {
  type        = string
  description = "API token for the live-CDN ioriver account (separate account from VOD)."
  sensitive   = true
  default     = ""
}

variable "dns_project" {
  type        = string
  description = "GCP project holding the Cloud DNS zones (see the private infra repo's projects/global/dns)."
  default     = "dns-managmenet"
}
