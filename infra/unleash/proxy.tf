
locals {
  proxy_service_name = "unleash-proxy-${var.env}"
  proxy_image_name   = "europe-west4-docker.pkg.dev/utils-332514/unleash/proxy:latest"
}

variable "unleash_proxy_client_key" {
  type = string
}

variable "unleash_api_token" {
  type = string
}

resource "google_cloud_run_service" "unleash_proxy" {
  project  = var.project
  provider = google-beta
  name     = local.proxy_service_name
  location = var.region

  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        "run.googleapis.com/sandbox"       = "gvisor"
      }
    }

    spec {
      container_concurrency = 100
      timeout_seconds       = 600
      service_account_name  = google_service_account.unleash.email

      containers {
        image = local.proxy_image_name

        ports {
          name           = "http1"
          container_port = 3000
        }

        env {
          name  = "UNLEASH_PROXY_CLIENT_KEYS"
          value = var.unleash_proxy_client_key
        }

        env {
          name  = "UNLEASH_URL"
          value = "${google_cloud_run_service.unleash_server.status[0].url}/api/"
        }
        env {
          name  = "UNLEASH_API_TOKEN"
          value = var.unleash_api_token
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "256Mi"
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
      template[0].spec[0].containers[0].image, // The image is managed by the deploy, we just need an initial one
      traffic[0].latest_revision,
      traffic[0].revision_name,
    ]
  }
}
