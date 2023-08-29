resource "google_storage_bucket" "website" {
  project = google_project.brunstadtv.project_id

  name                        = "btv-web-${var.env}-2"
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}


resource "google_storage_bucket_iam_member" "allusers" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "sem-read" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.semaphore_service_account}"
}

resource "google_storage_bucket_iam_member" "sem-write" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.semaphore_service_account}"
}

resource "google_compute_global_address" "website" {
  provider = google
  project  = google_project.brunstadtv.project_id
  name     = "website-lb-ip"
}

resource "google_compute_backend_bucket" "website" {
  provider    = google
  project     = google_project.brunstadtv.project_id
  name        = "website-backend"
  description = "Contains files needed by the website"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true
}

resource "google_compute_url_map" "website" {
  provider        = google
  project         = google_project.brunstadtv.project_id
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.website.self_link

  host_rule {
    hosts        = ["brunstad.tv", "www.brunstad.tv"]
    path_matcher = "redirect-to-app"
  }

  path_matcher {
    name            = "redirect-to-app"
    default_service = google_compute_backend_bucket.website.self_link

    path_rule {
      paths = [
        "/*", // We can't currently break /api because tvos is using it.
      ]

      url_redirect {
        host_redirect          = "app.bcc.media"
        https_redirect         = true
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        strip_query            = false
      }
    }
  }

  host_rule {
    hosts        = ["*"]
    path_matcher = "socials"
  }

  host_rule {
    hosts        = ["app.biblekids.io"]
    path_matcher = "biblekids"
  }

  path_matcher {
    default_service = "https://www.googleapis.com/compute/v1/projects/btv-platform-prod-2/global/backendBuckets/app-biblekids-io-gcs"
    name            = "biblekids"
  }

  path_matcher {
    name            = "socials"
    default_service = google_compute_backend_bucket.website.self_link

    path_rule {
      paths   = ["/episode/*"]
      service = google_compute_backend_service.rewriter.id
    }


    path_rule {
      paths = [
        "/privacy",
        "/personvern",
        "/privacy/*",
        "/personvern/*",
      ]

      url_redirect {
        host_redirect          = "bcc.media"
        https_redirect         = true
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        strip_query            = false
      }
    }
  }
}

resource "google_compute_target_https_proxy" "website" {
  provider         = google
  project          = google_project.brunstadtv.project_id
  name             = "website-target-proxy"
  url_map          = google_compute_url_map.website.self_link
  ssl_certificates = flatten([var.additional_key_path != "" ? [google_compute_ssl_certificate.additional_cert[0].self_link] : [], google_compute_managed_ssl_certificate.website.self_link, "https://www.googleapis.com/compute/v1/projects/btv-platform-prod-2/global/sslCertificates/app-biblekids-io"])
}

resource "google_compute_global_forwarding_rule" "default" {
  provider              = google
  project               = google_project.brunstadtv.project_id
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website.self_link
}

resource "google_compute_managed_ssl_certificate" "website" {
  provider = google-beta
  project  = google_project.brunstadtv.project_id
  name     = "website-cert"
  managed {
    domains = var.web_domains
  }
}

resource "google_compute_ssl_certificate" "additional_cert" {
  count       = var.additional_cert_path != "" ? 1 : 0
  project     = google_project.brunstadtv.project_id
  name_prefix = "bccmedia-"
  description = "Additional certificate for transitions"
  private_key = file("${var.basepath}/${var.additional_key_path}")
  certificate = file("${var.basepath}/${var.additional_cert_path}")

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "website-redirect" {
  name    = "website-redirect"
  project = google_project.brunstadtv.project_id

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT" // 301 redirect
    strip_query            = false
    https_redirect         = true // this is the magic
  }
}

resource "google_compute_target_http_proxy" "website-redirect" {
  name    = "website-redirect"
  project = google_project.brunstadtv.project_id
  url_map = google_compute_url_map.website-redirect.self_link
}

resource "google_compute_global_forwarding_rule" "website-redirect" {
  name       = "website-redirect"
  project    = google_project.brunstadtv.project_id
  target     = google_compute_target_http_proxy.website-redirect.self_link
  ip_address = google_compute_global_address.website.address
  port_range = "80"
}

