resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_13"
  project          = google_project.brunstadtv.project_id

  settings {
    tier              = var.db.tier
    availability_type = var.db.availability_type

    backup_configuration {
      location = "eu"
      enabled  = var.db.backups_enabled
      // googleapi: Error 400: Invalid request: Point in time recovery must be disabled when backup is disabled., invalid
      point_in_time_recovery_enabled = var.db.backups_enabled
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "off"
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 4500
      record_application_tags = true
      record_client_address   = false
    }

    maintenance_window {
      day          = 3
      hour         = 2
      update_track = "canary"
    }
  }

  lifecycle {
    ignore_changes = [settings[0].backup_configuration[0].location]
  }
}

resource "google_sql_database" "directus" {
  name     = "directus"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database" "unleash" {
  name     = "unleash"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "directus" {
  name     = "directus"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.postgres_directus_password.result
  type     = "BUILT_IN"
}

resource "google_sql_user" "api" {
  name     = "api"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.api_db_password.result
  type     = "BUILT_IN"
}

resource "google_sql_user" "background_worker" {
  name     = "background_worker"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.background_worker_db_password.result
  type     = "BUILT_IN"
}

resource "google_sql_user" "builder" {
  name     = "builder"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.builder_db_password.result
  type     = "BUILT_IN"
}

resource "google_sql_user" "unleash" {
  name     = "unleash"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.unleash_db_password.result
  type     = "BUILT_IN"
}

resource "google_sql_user" "onsite_backup" {
  name     = "onsite_backup"
  project  = google_project.brunstadtv.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.onsite_backup_db_password.result
  type     = "BUILT_IN"
}

resource "google_service_account" "db_backup" {
  project      = google_project.brunstadtv.project_id
  account_id   = "db-backup"
  display_name = "Service Account for backing up the database"
}

resource "google_service_account_key" "db_backup_key" {
  service_account_id = google_service_account.db_backup.name
}

resource "local_file" "db_backup_key" {
  content              = base64decode(google_service_account_key.db_backup_key.private_key)
  filename             = "${var.basepath}/keys/db-backup-google.secret.json"
  directory_permission = "0700"
  file_permission      = "0600"
}

resource "google_project_iam_binding" "cloudsql-client" {
  project = google_project.brunstadtv.project_id
  role    = "roles/cloudsql.client"

  members = [
    "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}",
    "serviceAccount:${google_service_account.directus.email}",
    "serviceAccount:${google_service_account.api.email}",
    "serviceAccount:${google_service_account.background_worker.email}",
    "serviceAccount:${module.unleash.service-account.email}",
    "serviceAccount:${google_service_account.db_backup.email}",
  ]
}



output "db-ip" {
  value = google_sql_database_instance.main.public_ip_address
}

output "backup-password" {
  sensitive = true
  value     = random_password.onsite_backup_db_password.result
}
