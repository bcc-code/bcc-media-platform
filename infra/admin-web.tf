resource "google_storage_bucket" "admin_web" {
  project = google_project.brunstadtv.project_id

  name                        = "btv-admin-web-${var.env}-2"
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_iam_member" "admin_web_allusers" {
  bucket = google_storage_bucket.admin_web.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "admin_web_sem_read" {
  bucket = google_storage_bucket.admin_web.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.semaphore_service_account}"
}

resource "google_storage_bucket_iam_member" "admin_web_sem_write" {
  bucket = google_storage_bucket.admin_web.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.semaphore_service_account}"
}

resource "google_compute_backend_bucket" "admin_web" {
  provider    = google
  project     = google_project.brunstadtv.project_id
  name        = "admin-web-backend"
  description = "Contains files needed by the admin website"
  bucket_name = google_storage_bucket.admin_web.name
  enable_cdn  = true
}

resource "google_compute_managed_ssl_certificate" "admin_web" {
  count    = length(var.admin_web_domains) > 0 ? 1 : 0
  provider = google-beta
  project  = google_project.brunstadtv.project_id
  name     = "admin-web-cert"
  managed {
    domains = var.admin_web_domains
  }
}
