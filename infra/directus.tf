locals {
  service_name_directus = "directus-${var.env}"
  image_name_directus   = "eu.gcr.io/${google_project.brunstadtv.project_id}/directus/directus"
}

resource "google_service_account" "directus" {
  project      = google_project.brunstadtv.project_id
  account_id   = "directus"
  display_name = "Service Account for directus cloudrun instance"
}

data "google_iam_policy" "directus-actas" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}"
    ]
  }
}

resource "google_service_account_iam_policy" "directus-iam" {
  service_account_id = google_service_account.directus.name
  policy_data        = data.google_iam_policy.directus-actas.policy_data
}

resource "google_cloud_run_service" "directus" {
  project  = google_project.brunstadtv.project_id
  provider = google-beta
  name     = local.service_name_directus
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
        "autoscaling.knative.dev/maxScale"      = "3"
        "run.googleapis.com/sandbox"            = "gvisor"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.main.connection_name
      }
    }

    spec {
      container_concurrency = 100
      timeout_seconds       = 600
      service_account_name  = google_service_account.directus.email

      containers {
        image = "${local.image_name_directus}:${var.branch}"

        ports {
          name           = "http1"
          container_port = 8055
        }

        env {
          name  = "DB_CONNECTION_STRING"
          value = "postgres:///${google_sql_database.directus.name}?host=/cloudsql/${google_sql_database_instance.main.connection_name}"
        }

        env {
          name  = "PGUSER"
          value = google_sql_user.directus.name
        }

        env {
          name  = "PRESSURE_LIMITER_ENABLED"
          value = "false"
        }

        dynamic "env" {
          for_each = module.directus_secrets.data
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
          for_each = var.directus_env
          iterator = v
          content {
            name  = v.key
            value = v.value
          }
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

resource "google_cloud_run_domain_mapping" "directus" {
  name     = "admin.${var.base_platform_domain}"
  location = var.gcp-region
  project  = google_project.brunstadtv.project_id

  metadata {
    namespace = google_project.brunstadtv.project_id
  }

  spec {
    route_name = google_cloud_run_service.directus.name
  }
}

resource "google_cloud_run_service_iam_policy" "noauth_directus" {
  project     = google_project.brunstadtv.project_id
  service     = google_cloud_run_service.directus.name
  location    = google_cloud_run_service.directus.location
  policy_data = data.google_iam_policy.noauth.policy_data
}
