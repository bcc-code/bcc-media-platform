locals {
  service_name = "background-worker-${var.env}"
  image_name   = "eu.gcr.io/${google_project.brunstadtv.project_id}/background-worker/background-jobs"
}

data "google_iam_policy" "bgjobs-actas" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}"
    ]
  }
}

resource "google_service_account" "background_worker" {
  project      = google_project.brunstadtv.project_id
  account_id   = "background-worker"
  display_name = "Service Account for Running background jobs"
}

resource "google_service_account_iam_policy" "background-worker-iam" {
  service_account_id = google_service_account.background_worker.name
  policy_data        = data.google_iam_policy.bgjobs-actas.policy_data
}

resource "google_project_iam_member" "cloudbuild_iam_gcradmin" {
  project = google_project.brunstadtv.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}"
}

resource "google_project_iam_member" "messaging_bgjobs" {
  project = google_project.brunstadtv.project_id
  role    = google_project_iam_custom_role.messaging_create.id
  member  = "serviceAccount:${google_service_account.background_worker.email}"
}

resource "google_project_iam_member" "firestore_bgjobs" {
  project = google_project.brunstadtv.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.background_worker.email}"
}

resource "google_cloud_run_service" "background_worker" {
  project  = google_project.brunstadtv.project_id
  provider = google-beta
  name     = local.service_name
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
        "autoscaling.knative.dev/maxScale"      = "100"
        "run.googleapis.com/sandbox"            = "gvisor"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.main.connection_name
      }
    }

    spec {
      container_concurrency = 100
      timeout_seconds       = 600
      service_account_name  = google_service_account.background_worker.email

      containers {
        image = "${local.image_name}:${var.branch}"

        ports {
          name           = "http1"
          container_port = 8000
        }

        env {
          name  = "GIN_MODE"
          value = "release"
        }

        env {
          name  = "DB_CONNECTION_STRING"
          value = "postgres:///${google_sql_database.directus.name}?host=/cloudsql/${google_sql_database_instance.main.connection_name}"
        }

        env {
          name  = "PGUSER"
          value = google_sql_user.background_worker.name
        }

        dynamic "env" {
          for_each = module.background_worker_secrets.data
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
          for_each = var.background_worker_env
          iterator = v
          content {
            name  = v.key
            value = v.value
          }
        }

        env {
          name  = "AWS_MEDIAPACKAGE_ROLE"
          value = aws_iam_role.mediapackage.arn
        }

        env {
          name  = "AWS_DEFAULT_REGION"
          value = local.aws_region
        }

        env {
          name  = "AWS_INGEST_BUCKET"
          value = aws_s3_bucket.vod-asset-ingest-bucket.id
        }

        env {
          name  = "AWS_STORAGE_BUCKET"
          value = aws_s3_bucket.vod-asset-storage-bucket.id
        }

        env {
          name  = "DIRECTUS_URL"
          value = "${google_cloud_run_service.directus.status[0].url}/"
        }

        env {
          name  = "REDIS_ADDRESS"
          value = var.redis_enable ? "${module.redis[0].host}:${module.redis[0].port}" : var.redis_address
        }

        env {
          name  = "REDIS_USERNAME"
          value = var.redis_username
        }

        env {
          name  = "REDIS_DATABASE"
          value = var.redis_database
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

resource "google_pubsub_topic" "background_worker" {
  project                    = google_project.brunstadtv.project_id
  name                       = "background_worker"
  message_retention_duration = "86600s"
}

data "google_iam_policy" "background_worker_topic" {
  binding {
    role = google_project_iam_custom_role.pubsub_publish_read.id
    members = [
      "serviceAccount:${google_service_account.nodered.email}",
      "serviceAccount:${google_service_account.directus.email}",
    ]
  }
}

resource "google_pubsub_topic_iam_policy" "background_worker_topic" {
  project     = google_project.brunstadtv.project_id
  topic       = google_pubsub_topic.background_worker.name
  policy_data = data.google_iam_policy.background_worker_topic.policy_data
}

resource "google_pubsub_subscription" "push_background_worker" {
  project = google_project.brunstadtv.project_id
  name    = "background_worker_google"
  topic   = google_pubsub_topic.background_worker.name

  ack_deadline_seconds = 600

  retry_policy {
    maximum_backoff = "600s"
    minimum_backoff = "10s"
  }

  /*
   * This is the actual default and it doesn't seem possible to remove
   * it using terraform. You can set it to never expire in the console
   *
  expiration_policy {

    ttl = "7days"
  }
  */

  push_config {
    push_endpoint = "${google_cloud_run_service.background_worker.status[0].url}/api/message"
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  project     = google_project.brunstadtv.project_id
  service     = google_cloud_run_service.background_worker.name
  location    = google_cloud_run_service.background_worker.location
  policy_data = data.google_iam_policy.noauth.policy_data
}
