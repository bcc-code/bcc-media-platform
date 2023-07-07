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
  type    = string
  default = ""
}

variable "branch" {
  type    = string
  default = ""
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

variable "db" {
  type = map(any)
}

variable "db-tier" {
  type    = string
  default = "db-f1-micro"
}

variable "views_refresh_schedule" {
  type    = string
  default = "0 * * * *"
}

variable "search_reindex_schedule" {
  type    = string
  default = "0 0 * * *"
}

variable "translations_sync_schedule" {
  type    = string
  default = "0 * * * *"
}

variable "answers_sync_schedule" {
  type    = string
  default = "0 * * * *"
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
  type    = string
  default = ""
}

variable "additional_key_path" {
  type    = string
  default = ""
}

variable "monitoring_enabled" {
  type    = bool
  default = false
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
  type    = bool
  default = false
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
