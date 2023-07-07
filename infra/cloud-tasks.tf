resource "google_cloud_tasks_queue" "worker" {
  project  = google_project.brunstadtv.project_id
  name     = "worker"
  location = "europe-west1"
}

data "google_iam_policy" "tasks_editor" {
  binding {
    role = "roles/editor"
    members = [
      "serviceAccount:${google_service_account.background_worker.email}",
    ]
  }
}

resource "google_cloud_tasks_queue_iam_policy" "policy" {
  project     = google_cloud_tasks_queue.worker.project
  location    = google_cloud_tasks_queue.worker.location
  name        = google_cloud_tasks_queue.worker.name
  policy_data = data.google_iam_policy.tasks_editor.policy_data
}