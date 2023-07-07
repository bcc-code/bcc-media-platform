

resource "google_pubsub_topic" "cloud_builds" {
  project = google_project.brunstadtv.project_id

  # The Cloud builds submit notifications to a *hardcoded* topic in the project they run in
  # so the name must be `cloud-builds`
  name = "cloud-builds"

  message_retention_duration = "600s"
}

resource "google_pubsub_subscription" "push_cloud_builds_gcs" {
  project = google_project.brunstadtv.project_id
  name    = "push_cloud_builds"
  topic   = google_pubsub_topic.cloud_builds.name

  ack_deadline_seconds = 60

  retry_policy {
    maximum_backoff = "600s"
    minimum_backoff = "10s"
  }

  expiration_policy {
    ttl = "30240000s" // 350 days
  }

  push_config {
    # This is the notifier that will write to GCS for the LED panel
    push_endpoint = "https://notifiers-fo4zdbrjua-ez.a.run.app"
  }
}
