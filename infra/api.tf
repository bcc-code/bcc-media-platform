locals {
  service_name_api    = "api-${var.env}"
  image_name_api      = "eu.gcr.io/${google_project.brunstadtv.project_id}/api/api"
  cf_signing_key_path = "/secrets/aws.pem"
  az_signing_key_path = "/secrets2/azure.pem"
}

resource "google_service_account_iam_policy" "api-iam" {
  service_account_id = google_service_account.api.name
  policy_data        = data.google_iam_policy.bgjobs-actas.policy_data
}

resource "google_project_iam_binding" "api-profiling" {
  project = google_project.brunstadtv.project_id
  role    = "roles/cloudprofiler.agent"
  members = [
    "serviceAccount:${google_service_account.api.email}"
  ]
}

resource "google_service_account" "api" {
  project      = google_project.brunstadtv.project_id
  account_id   = "gqlapi"
  display_name = "Service Account for the API"
}


resource "google_cloud_run_service" "api" {
  project  = google_project.brunstadtv.project_id
  provider = google-beta
  name     = local.service_name_api
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
        "autoscaling.knative.dev/maxScale"      = "10"
        "run.googleapis.com/sandbox"            = "gvisor"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.main.connection_name
      }
    }

    spec {
      container_concurrency = 300
      timeout_seconds       = 60
      service_account_name  = google_service_account.api.email

      containers {
        image = "${local.image_name_api}:${var.branch}"

        ports {
          name           = "http1"
          container_port = 8000
        }

        env {
          name  = "DB_CONNECTION_STRING"
          value = "host='/cloudsql/${google_sql_database_instance.main.connection_name}' dbname='${google_sql_database.directus.name}'"
        }

        env {
          name  = "PGUSER"
          value = google_sql_user.api.name
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
          name  = "AZ_SIGNING_KEY_PATH"
          value = local.az_signing_key_path
        }

        env {
          name  = "LEGACY_CDN_DOMAIN"
          value = var.legacy_cdn_domain
        }

        env {
          name  = "FILES_CDN_DOMAIN"
          value = "files.${var.base_platform_domain}"
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

        env {
          name  = "AWS_DEFAULT_REGION"
          value = local.aws_region
        }

        env {
          name  = "AWS_TEMP_BUCKET"
          value = aws_s3_bucket.btv-tempstorage.bucket
        }

        dynamic "env" {
          for_each = module.api_secrets.data
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
          for_each = module.api_secret_files.data
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
          for_each = var.api_env
          iterator = v
          content {
            name  = v.key
            value = v.value
          }
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "1Gi"
          }
        }

        dynamic "volume_mounts" {
          for_each = module.api_secret_files.data
          iterator = v
          content {
            mount_path = dirname(v.value.name)
            name       = v.value.secret_name
          }
        }

      }


      dynamic "volumes" {
        for_each = module.api_secret_files.data
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
      metadata[0].labels,
      metadata[0].annotations,
      template[0].metadata[0].annotations,
      template[0].metadata[0].labels,
      template[0].spec[0].containers[0].image, // The image is managed by the deploy, we just need an initial one
      traffic[0].latest_revision,
      traffic[0].revision_name,
    ]
  }
}

resource "google_cloud_run_domain_mapping" "api" {
  name     = "api.${var.base_platform_domain}"
  location = var.gcp-region
  project  = google_project.brunstadtv.project_id

  metadata {
    namespace = google_project.brunstadtv.project_id
  }

  spec {
    route_name = google_cloud_run_service.api.name
  }
}

resource "google_cloud_run_service_iam_policy" "noauth-api" {
  project     = google_project.brunstadtv.project_id
  service     = google_cloud_run_service.api.name
  location    = google_cloud_run_service.api.location
  policy_data = data.google_iam_policy.noauth.policy_data
}


resource "tls_private_key" "redirect" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "redirect-jwt-pub" {
  sensitive = true
  value     = tls_private_key.redirect.public_key_pem
}

