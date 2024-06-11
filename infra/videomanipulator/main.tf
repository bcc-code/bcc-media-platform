terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.35.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.35.0"
    }
  }
}

output "url" {
  value = google_cloud_run_service.videomanipulator.status[0].url
}

output "api_key" {
  value = random_password.api_key.result
}

output "service_account" {
  value = google_service_account.videomanipulator
}


variable "project_id" {
  description = "The project id"
}

variable "env" {
  description = "The environment to deploy to"
}

variable "gcp_region" {
  description = "The region to deploy to"
}

resource "google_service_account" "videomanipulator" {
  project      = var.project_id
  account_id   = "videomanipulator"
  display_name = "Service Account for videomanipulator cloudrun instance"
}

resource "random_password" "api_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_cloud_run_service" "videomanipulator" {
  project  = var.project_id
  provider = google-beta
  name     = "videomanipulator-${var.env}"
  location = var.gcp_region

  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "3"
        "run.googleapis.com/sandbox"       = "gvisor"
      }
    }

    spec {
      container_concurrency = 100
      timeout_seconds       = 60
      service_account_name  = google_service_account.videomanipulator.email

      containers {
        image = "europe-west4-docker.pkg.dev/utils-332514/btv-platform/videomanipulator:master"

        ports {
          name           = "http1"
          container_port = 8000
        }

        env {
          name  = "API_KEY"
          value = random_password.api_key.result
        }

        resources {
          limits = {
            cpu    = "2000m"
            memory = "2Gi"
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
      metadata[0].labels,
      template[0].metadata[0].labels,
      metadata[0].annotations,
      template[0].metadata[0].annotations,
      template[0].spec[0].containers[0].image, // The image is managed by the deploy, we just need an initial one
      traffic[0].latest_revision,
      traffic[0].revision_name,
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  project     = var.project_id
  service     = google_cloud_run_service.videomanipulator.name
  location    = google_cloud_run_service.videomanipulator.location
  policy_data = data.google_iam_policy.noauth.policy_data
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
