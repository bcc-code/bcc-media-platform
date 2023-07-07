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
  /*
  host_rule {
    hosts = ["brunstad.tv", "www.brunstad.tv"]
    path_matcher = "redirect-to-app"
  }

  path_matcher {
    name            = "redirect-to-app"
    default_service = google_compute_backend_bucket.website.self_link

    path_rule {
      paths = [
        "/",
 //       "/*", // We can't currently break /api because tvos is using it.
      ]

      url_redirect {
        host_redirect          = "app.bcc.media"
        https_redirect         = true
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        strip_query            = false
      }
    }
  }
*/
  host_rule {
    hosts        = ["*"]
    path_matcher = "socials"
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
        "/api/*",
        "/Content/*",
        "/static/css/videojs-brunstadtv-skin.css",
        "/static/video.js/video-js.min.css",
        "/static/video.js/video.min.js",
        "/static/js/videojs-create-player.js"
      ]
      service = google_compute_backend_service.old-api.id

      route_action {
        url_rewrite {
          host_rewrite = "old.brunstad.tv"
        }
      }
    }

    path_rule {
      paths = [
        "/tvlogin/*",
      ]

      url_redirect {
        host_redirect          = "old.brunstad.tv"
        https_redirect         = true
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        strip_query            = false
      }
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
  ssl_certificates = flatten([var.additional_key_path != "" ? [google_compute_ssl_certificate.additional_cert[0].self_link] : [], google_compute_managed_ssl_certificate.website.self_link])
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


# Rewrite /api to old api
resource "google_compute_global_network_endpoint_group" "old-api" {
  project               = google_project.brunstadtv.project_id
  name                  = "old-api"
  default_port          = "443"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_global_network_endpoint" "old-api-endpoint" {
  project                       = google_project.brunstadtv.project_id
  global_network_endpoint_group = google_compute_global_network_endpoint_group.old-api.name
  fqdn                          = "old.brunstad.tv"
  port                          = 443
}

resource "google_compute_backend_service" "old-api" {
  project                         = google_project.brunstadtv.project_id
  name                            = "old-api"
  enable_cdn                      = false
  timeout_sec                     = 10
  connection_draining_timeout_sec = 10

  cdn_policy {
    cache_mode                   = "USE_ORIGIN_HEADERS"
    client_ttl                   = 0
    default_ttl                  = 0
    max_ttl                      = 0
    signed_url_cache_max_age_sec = 3600
    serve_while_stale            = 604800 //1 week
    cache_key_policy {
      include_host         = false
      include_protocol     = false
      include_query_string = true
    }
  }

  # custom_request_headers          = ["host: ${google_compute_global_network_endpoint.old-api-endpoint.fqdn}"]
  # custom_response_headers         = ["X-Cache-Hit: {cdn_cache_status}"]

  backend {
    group = google_compute_global_network_endpoint_group.old-api.self_link
  }
}
