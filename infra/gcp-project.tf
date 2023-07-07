
resource "google_project" "brunstadtv" {
  name       = "BrunstadTV Platform - ${var.env}"
  project_id = "btv-platform-${var.env}-2"
  //org_id          = "537476825780"
  folder_id       = "442661614205"
  billing_account = "01E4EC-0B9EF5-3B38CC"
}

resource "google_project_iam_binding" "project-owners" {
  project = google_project.brunstadtv.project_id
  role    = "roles/owner"
  members = [
    "user:matjaz.debelak@bcc.media",
    "user:andreas.gangso@bcc.media",
    "user:fredrik.vedvik@bcc.media",
  ]
}

resource "google_project_iam_binding" "iam-metrics-directus" {
  project = google_project.brunstadtv.project_id
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:${google_service_account.directus.email}",
    "serviceAccount:${google_service_account.background_worker.email}",
    "serviceAccount:${google_service_account.api.email}",
  ]
}

resource "google_project_iam_binding" "iam-logging-directus" {
  project = google_project.brunstadtv.project_id
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:${google_service_account.directus.email}",
    "serviceAccount:${google_service_account.background_worker.email}",
    "serviceAccount:${google_service_account.api.email}",
  ]
}

resource "google_project_iam_binding" "iam-tracing-directus" {
  project = google_project.brunstadtv.project_id
  role    = "roles/cloudtrace.agent"
  members = [
    "serviceAccount:${google_service_account.directus.email}",
    "serviceAccount:${google_service_account.background_worker.email}",
    "serviceAccount:${google_service_account.api.email}",
  ]
}


resource "google_project_service" "buildapi" {
  project            = google_project.brunstadtv.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "kmsapi" {
  project            = google_project.brunstadtv.project_id
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "computeapi" {
  project            = google_project.brunstadtv.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "vpcaccessapi" {
  project            = google_project.brunstadtv.project_id
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "runapi" {
  project            = google_project.brunstadtv.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "kms" {
  project            = google_project.brunstadtv.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  project            = google_project.brunstadtv.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudtrace" {
  project            = google_project.brunstadtv.project_id
  service            = "cloudtrace.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudscheduler" {
  project            = google_project.brunstadtv.project_id
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudtasks" {
  project            = google_project.brunstadtv.project_id
  service            = "cloudtasks.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service_identity" "cloudbuils_sa" {
  provider = google-beta
  project  = google_project.brunstadtv.project_id
  service  = "cloudbuild.googleapis.com"
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

