# Live delivery via ioriver vCDN (CloudFront + Fastly under ioriver-managed
# tenancy — no provider credentials of our own). This is the `ioriver` half of
# the stream-proxy live upstream; the direct-CloudFront half (/secrets5,
# LIVE_CF_*) is provisioned outside terraform.
#
# Everything is gated on var.live_cdn (null in dev/sta): with it unset this
# file creates nothing and the empty ioriver token is never used.

locals {
  live_cdn_enabled = var.live_cdn != null
}

# RSA key pair for live URL signing: the public half is registered with
# ioriver, the private half is what stream-proxy signs with (delivered to the
# service via Secret Manager below). Rotating = taint this resource.
resource "tls_private_key" "live_ioriver_signing" {
  count = local.live_cdn_enabled ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

# Required by the ioriver signing-key API alongside the RSA public key (used
# for HMAC-style providers); stream-proxy only consumes it for Akamai, which
# is not enabled here.
resource "random_password" "live_ioriver_encryption_key" {
  count = local.live_cdn_enabled ? 1 : 0

  length  = 32
  special = false
}

resource "ioriver_certificate" "live" {
  count = local.live_cdn_enabled ? 1 : 0

  name = "live-cdn"
  type = "MANAGED"
  cn   = jsonencode([var.live_cdn.hostname]) # the API wants a JSON array of domains in a string
}

resource "ioriver_service" "live" {
  count = local.live_cdn_enabled ? 1 : 0

  name        = "live-cdn"
  description = "Livestream delivery (managed by terraform, bcc-media-platform/infra)"
  certificate = ioriver_certificate.live[0].id

  config = {
    origins = [
      {
        name = "live-origin"
        custom_origin = {
          host     = var.live_cdn.origin_host
          protocol = "https"
        }
      }
    ]

    domains = [
      {
        domain = var.live_cdn.hostname
        mappings = [
          { target_mapping = "live-origin" }
        ]
      }
    ]

    behaviors = {
      default = {
        actions = {
          url_signing          = null
          origin_cache_control = true
          cache_ttl            = 1209600
          host_header = {
            use_origin_host = true
          }
          status_codes_ttl = [
            {
              cache_behavior = "BYPASS"
              cache_ttl      = 0
              status_code    = "4xx"
            },
            {
              cache_behavior = "BYPASS"
              cache_ttl      = 0
              status_code    = "5xx"
          }]
          cache_key = {
            headers = [
              {
                header = "Host"
              }
            ]
            query_strings = {
              type = "all"
            }
          }
          allowed_methods = [
            {
              method = "GET"
            },
            {
              method = "HEAD"
            },
            {
              method = "OPTIONS"
            }
          ]
        }
      }
    }
  }
}

# The CDN provider attached to the service: ioriver's bundled vCDN
# (CloudFront + Fastly under ioriver's own accounts — hence no
# account_provider). The attachment was created outside terraform when the
# service was first set up; bring it under management with
#   terragrunt import 'module.bcc-media-platform.ioriver_service_provider.live[0]' "<service-id>,<provider-id>"
# (ids from GET /api/v1/services/ and /services/<id>/providers/; adjust the
# module prefix to wherever this file is instantiated).
resource "ioriver_service_provider" "live" {
  count = local.live_cdn_enabled ? 1 : 0

  service = ioriver_service.live[0].id
}

# The URL signing key itself is NOT terraform-managed and CANNOT be: since
# v1.0.0 ioriver_url_signing_key is a gutted deprecated stub — it still shows
# up in the provider docs, but Create/Update/Import all return a hard
# "resource is deprecated" error and Read silently drops it from state. Only
# the REST API supports it. It is created out-of-band from the key material above
# by scripts/create-live-ioriver-signing-key.sh, which prints the per-CDN key
# ids ("Cloudfront"/"Fastly") to paste into stream_proxy_env in the env tfvars
# as LIVE_IORIVER_CLOUDFRONT_KEY_ID / LIVE_IORIVER_FASTLY_KEY_ID.
#
# Bootstrap order (the API rejects a url_signing behavior until a key exists):
# apply with url_signing = false below, run the script, set url_signing = true,
# apply again.

# --- DNS (bcc-media zone in the shared DNS project) ---

resource "google_dns_record_set" "live_cdn" {
  count    = local.live_cdn_enabled ? 1 : 0
  provider = google.dns

  managed_zone = "bcc-media"
  name         = "${var.live_cdn.hostname}."
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${trimsuffix(ioriver_service.live[0].cname, ".")}."]
}

# ACME validation for the MANAGED certificate. ioriver returns `challenges` as
# a JSON-ish string (single-quoted); with a single-CN cert there is exactly one
# challenge, and only its value is unknown before the first apply, so this
# resolves in the same apply. If the format ever defeats the parse, the raw
# string is in the certificate state — create the CNAME by hand.
resource "google_dns_record_set" "live_cdn_acme" {
  count    = local.live_cdn_enabled ? 1 : 0
  provider = google.dns

  managed_zone = "bcc-media"
  name         = "_acme-challenge.${var.live_cdn.hostname}."
  type         = "CNAME"
  ttl          = 300
  rrdatas = [
    "${trimsuffix(jsondecode(replace(ioriver_certificate.live[0].challenges, "'", "\""))[0].value, ".")}."
  ]
}

# --- Private signing key → stream-proxy (mounted in stream-proxy.tf) ---

resource "google_secret_manager_secret" "live_ioriver_signing_key" {
  count   = local.live_cdn_enabled ? 1 : 0
  project = google_project.brunstadtv.project_id

  secret_id = "live_ioriver_signing_key"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "live_ioriver_signing_key" {
  count       = local.live_cdn_enabled ? 1 : 0
  secret      = google_secret_manager_secret.live_ioriver_signing_key[0].id
  secret_data = tls_private_key.live_ioriver_signing[0].private_key_pem
}

resource "google_secret_manager_secret_iam_member" "live_ioriver_signing_key_stream_proxy" {
  count   = local.live_cdn_enabled ? 1 : 0
  project = google_project.brunstadtv.project_id

  secret_id = google_secret_manager_secret.live_ioriver_signing_key[0].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.stream_proxy.email}"
}

output "live_cdn_hostname" {
  value = local.live_cdn_enabled ? var.live_cdn.hostname : null
}
