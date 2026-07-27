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
  cn   = var.live_cdn.hostname
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
          # Signed URLs only, and cache per the MediaPackage origin's
          # Cache-Control (short for live manifests, long for segments).
          url_signing          = true
          origin_cache_control = true
        }
      }
    }
  }
}

# The backend-facing key ids land in provider_keys (map keyed "Cloudfront" /
# "Fastly") and are wired straight into the stream-proxy env in
# stream-proxy.tf — nothing to copy into tfvars.
resource "ioriver_url_signing_key" "live" {
  count = local.live_cdn_enabled ? 1 : 0

  service        = ioriver_service.live[0].id
  name           = "live-cdn"
  public_key     = tls_private_key.live_ioriver_signing[0].public_key_pem
  encryption_key = random_password.live_ioriver_encryption_key[0].result
}

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

output "live_ioriver_provider_keys" {
  value     = local.live_cdn_enabled ? ioriver_url_signing_key.live[0].provider_keys : null
  sensitive = true
}
