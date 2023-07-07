
resource "google_secret_manager_secret" "secret" {
  for_each  = var.secrets
  project   = var.project
  secret_id = each.key
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version" {
  for_each    = var.secrets
  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value.data
  depends_on  = [google_secret_manager_secret_iam_policy.reader-policy]
}

data "google_iam_policy" "reader" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = var.secret_accessors
  }
}

resource "google_secret_manager_secret_iam_policy" "reader-policy" {
  provider    = google-beta
  for_each    = var.secrets
  project     = var.project
  secret_id   = google_secret_manager_secret.secret[each.key].secret_id
  policy_data = data.google_iam_policy.reader.policy_data
}

locals {
  data = [
    for key, value in var.secrets : {
      name           = value.name
      secret_version = substr(google_secret_manager_secret_version.secret-version[key].id, -1, -1)
      secret_name    = google_secret_manager_secret.secret[key].secret_id
    }
  ]
}
