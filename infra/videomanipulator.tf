
module "videomanipulator" {
  source     = "./videomanipulator"
  env        = var.env
  project_id = google_project.brunstadtv.project_id
  gcp_region = var.gcp-region
  providers = {
    google      = google
    google-beta = google-beta
  }
}

data "google_iam_policy" "videomanipulator-actas" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}"
    ]
  }
}

resource "google_service_account_iam_policy" "videomanipulator-iam" {
  service_account_id = module.videomanipulator.service_account.name
  policy_data        = data.google_iam_policy.videomanipulator-actas.policy_data
}
