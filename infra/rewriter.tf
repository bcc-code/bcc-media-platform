resource "google_service_account" "rewriter" {
  project      = google_project.brunstadtv.project_id
  account_id   = "rewriter"
  display_name = "Service Account for web rewriter"
}

data "google_iam_policy" "rewriter-actas" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}"
    ]
  }
}

resource "google_service_account_iam_policy" "rewriter-iam" {
  service_account_id = google_service_account.rewriter.name
  policy_data        = data.google_iam_policy.rewriter-actas.policy_data
}

resource "google_cloud_run_service" "rewriter" {
  project  = google_project.brunstadtv.project_id
  provider = google-beta
  name     = "rewriter-${var.env}"
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
        "autoscaling.knative.dev/maxScale" = "100"
        "run.googleapis.com/sandbox"       = "gvisor"
      }
    }

    spec {
      container_concurrency = 100
      timeout_seconds       = 600
      service_account_name  = google_service_account.rewriter.email

      containers {
        image = "europe-west4-docker.pkg.dev/utils-332514/btv-platform/rewriter:ba4aa63"

        ports {
          name           = "http1"
          container_port = 8000
        }

        # dynamic "env" {
        #   for_each = module.rewriter_secrets.data
        #   iterator = v
        #   content {
        #     name = v.value.name
        #     value_from {
        #       secret_key_ref {
        #         key  = v.value.secret_version
        #         name = v.value.secret_name
        #       }
        #     }
        #   }
        # }

        dynamic "env" {
          for_each = var.rewriter_env
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

resource "google_cloud_run_service_iam_policy" "noauth-rewriter" {
  project     = google_project.brunstadtv.project_id
  service     = google_cloud_run_service.rewriter.name
  location    = google_cloud_run_service.rewriter.location
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_compute_region_network_endpoint_group" "rewriter_neg" {
  name                  = "rewriter-neg"
  project               = google_project.brunstadtv.project_id
  network_endpoint_type = "SERVERLESS"
  region                = var.gcp-region

  cloud_run {
    service = google_cloud_run_service.rewriter.name
  }
}

resource "google_compute_backend_service" "rewriter" {
  name       = "rewriter"
  project    = google_project.brunstadtv.project_id
  enable_cdn = true

  backend {
    group = google_compute_region_network_endpoint_group.rewriter_neg.id
  }
}
