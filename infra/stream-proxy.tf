locals {
  service_name_stream_proxy = "stream-proxy-${var.env}"
  image_name_stream_proxy   = "europe-west4-docker.pkg.dev/utils-332514/btv-platform/stream-proxy"

  stream_proxy_cloudfront_direct_key_files = [
    for v in module.api_secret_files.data : v if v.name == local.cf_signing_key_path
  ]
  stream_proxy_ioriver_key_files = [
    for v in module.api_secret_files.data : v if v.name == local.ioriver_signing_key_path
  ]
}

resource "google_service_account" "stream_proxy" {
  project      = google_project.brunstadtv.project_id
  account_id   = "stream-proxy"
  display_name = "Service Account for stream-proxy"
}

data "google_iam_policy" "stream-proxy-actas" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}",
      "serviceAccount:${google_project.brunstadtv.number}@cloudbuild.gserviceaccount.com",
    ]
  }
}

resource "google_service_account_iam_policy" "stream-proxy-iam" {
  service_account_id = google_service_account.stream_proxy.name
  policy_data        = data.google_iam_policy.stream-proxy-actas.policy_data
}

resource "google_cloud_run_service" "stream_proxy" {
  project  = google_project.brunstadtv.project_id
  provider = google-beta
  name     = local.service_name_stream_proxy
  location = var.gcp-region

  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "50"
        "run.googleapis.com/sandbox"       = "gvisor"
      }
    }

    spec {
      container_concurrency = 100
      timeout_seconds       = 2
      service_account_name  = google_service_account.stream_proxy.email

      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello" // "${local.image_name_stream_proxy}:${var.branch}"

        env {
          name  = "ENVIRONMENT"
          value = var.env
        }

        env {
          name  = "GIN_MODE"
          value = "release"
        }

        env {
          name  = "CF_SIGNING_KEY_PATH"
          value = local.cf_signing_key_path
        }

        env {
          name  = "IORIVER_SIGNING_KEY_PATH"
          value = local.ioriver_signing_key_path
        }

        dynamic "env" {
          for_each = module.stream_proxy_secrets.data
          iterator = v
          content {
            name = v.value.name
            value_from {
              secret_key_ref {
                key  = v.value.secret_version
                name = v.value.secret_name
              }
            }
          }
        }

        dynamic "env" {
          for_each = var.stream_proxy_env
          iterator = v
          content {
            name  = v.key
            value = v.value
          }
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "256Mi"
          }
        }

        dynamic "volume_mounts" {
          for_each = local.stream_proxy_cloudfront_direct_key_files
          iterator = v
          content {
            mount_path = dirname(v.value.name)
            name       = v.value.secret_name
          }
        }

        dynamic "volume_mounts" {
          for_each = local.stream_proxy_ioriver_key_files
          iterator = v
          content {
            mount_path = dirname(v.value.name)
            name       = v.value.secret_name
          }
        }
      }

      dynamic "volumes" {
        for_each = local.stream_proxy_cloudfront_direct_key_files
        iterator = v
        content {
          name = v.value.secret_name
          secret {
            secret_name = v.value.secret_name
            items {
              key  = "latest"
              path = basename(v.value.name)
            }
          }
        }
      }

      dynamic "volumes" {
        for_each = local.stream_proxy_ioriver_key_files
        iterator = v
        content {
          name = v.value.secret_name
          secret {
            secret_name = v.value.secret_name
            items {
              key  = "latest"
              path = basename(v.value.name)
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = []

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
      template[0].metadata[0].annotations,
      template[0].metadata[0].labels,
      template[0].spec[0].containers[0].image,
      traffic[0].latest_revision,
      traffic[0].revision_name,
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth-stream-proxy" {
  project     = google_project.brunstadtv.project_id
  service     = google_cloud_run_service.stream_proxy.name
  location    = google_cloud_run_service.stream_proxy.location
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_domain_mapping" "stream_proxy" {
  name     = "stream.${var.base_platform_domain}"
  location = var.gcp-region
  project  = google_project.brunstadtv.project_id

  metadata {
    namespace = google_project.brunstadtv.project_id
  }

  spec {
    route_name = google_cloud_run_service.stream_proxy.name
  }
}
