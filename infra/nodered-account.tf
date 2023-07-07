resource "google_service_account" "nodered" {
  project      = google_project.brunstadtv.project_id
  account_id   = "nodered"
  display_name = "Service Account for NodeRed onsite instance"
}

resource "google_service_account_key" "nodered-key" {
  service_account_id = google_service_account.nodered.name
}

resource "local_file" "service_account_key" {
  content              = base64decode(google_service_account_key.nodered-key.private_key)
  filename             = "${var.basepath}/keys/nodered-google.secret.json"
  directory_permission = "0700"
  file_permission      = "0600"
}
