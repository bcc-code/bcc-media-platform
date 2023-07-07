terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.35.0"
    }
  }
}

resource "google_compute_network" "redis-network" {
  project = var.project
  name    = "redis-network"
}

resource "google_compute_global_address" "service_range" {
  project       = var.project
  name          = "address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.redis-network.id
}

resource "google_redis_instance" "cache" {
  project            = var.project
  name               = "btv-cache"
  display_name       = "BTV Cache"
  memory_size_gb     = 1
  authorized_network = google_compute_network.redis-network.id
}

resource "google_vpc_access_connector" "connector" {
  project        = var.project
  region         = var.region
  name           = "vpcconn"
  provider       = google-beta
  ip_cidr_range  = "10.8.0.0/28"
  max_throughput = 300
  network        = google_compute_network.redis-network.name
}

resource "google_compute_router" "router" {
  project  = var.project
  region   = var.region
  name     = "router"
  provider = google-beta
  network  = google_compute_network.redis-network.id
}

resource "google_compute_router_nat" "router_nat" {
  project                            = var.project
  region                             = var.region
  name                               = "nat"
  provider                           = google-beta
  router                             = google_compute_router.router.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}
