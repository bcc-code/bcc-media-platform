

// Seaphore access to submit builds
resource "google_project_iam_member" "semaphore_viewer" {
  project = google_project.brunstadtv.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${var.semaphore_service_account}"
}

resource "google_project_iam_member" "semaphore_serviceUsageConsumer" {
  project = google_project.brunstadtv.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "serviceAccount:${var.semaphore_service_account}"
}

resource "google_project_iam_member" "semaphore_buildEditor" {
  project = google_project.brunstadtv.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${var.semaphore_service_account}"
}

