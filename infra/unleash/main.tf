terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.35.0"
    }
  }
}

locals {
  service_name = "unleash-server-${var.env}"
  image_name   = "unleashorg/unleash-server:4.21.0"
}

variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "run_env" {
  type = map(any)
}

variable "dbname" {
  type = string
}

variable "dbuser" {
  type = string
}

variable "dbpass" {
  type      = string
  sensitive = true
}

variable "unleash_url" {
  type = string
}

variable "dbconnname" {
  type    = string
  default = ""
}

module "unleash_secrets" {
  source  = "../gcp-secrets"
  project = var.project
  secrets = { postgres_unleash_password = {
    name = "PGPASSWORD"
    data = var.dbpass
    }
  }
  secret_accessors = ["serviceAccount:${google_service_account.unleash.email}"]
}

resource "google_service_account" "unleash" {
  project      = var.project
  account_id   = "unleash"
  display_name = "Unleash service acc"
}

resource "google_cloud_run_service" "unleash_server" {
  project  = var.project
  provider = google-beta
  name     = local.service_name
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
        "autoscaling.knative.dev/maxScale"      = "1"
        "run.googleapis.com/sandbox"            = "gvisor"
        "run.googleapis.com/cloudsql-instances" = var.dbconnname
      }
    }

    spec {
      container_concurrency = 1000
      timeout_seconds       = 600
      service_account_name  = google_service_account.unleash.email

      containers {
        image = local.image_name

        ports {
          name           = "http1"
          container_port = 4242
        }

        env {
          name  = "DATABASE_URL"
          value = "postgres:///${var.dbname}?host=/cloudsql/${var.dbconnname}"
        }

        env {
          name  = "DATABASE_SSL"
          value = "false"
        }

        env {
          name = "UNLEASH_URL"
          // This is somwhat problematic, as it actually needs toe value from the cloud run service itself, which is not available directly
          // so the value is passed in via a config
          value = var.unleash_url // "https://unleash-server-dev-xijv7znjhq-ez.a.run.app"
        }

        env {
          name  = "PGUSER"
          value = var.dbuser
        }

        dynamic "env" {
          for_each = module.unleash_secrets.data
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
          for_each = var.run_env
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
      template[0].spec[0].container_concurrency
    ]
  }
}

output "service-account" {
  value = google_service_account.unleash
}
