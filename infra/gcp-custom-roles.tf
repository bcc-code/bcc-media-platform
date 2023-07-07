resource "google_project_iam_custom_role" "pubsub_publish_read" {
  role_id     = "pubsubPublishRead"
  project     = google_project.brunstadtv.project_id
  title       = "Pubsub publish and read"
  description = "Needed for NodeRed"
  permissions = [
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.topics.publish",
  ]
}

resource "google_project_iam_custom_role" "messaging_create" {
  role_id     = "messagingCreate"
  project     = google_project.brunstadtv.project_id
  title       = "Messaging Create"
  description = "Needed to push notifications"
  permissions = [
    "cloudmessaging.messages.create",
  ]
}
