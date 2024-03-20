resource "random_password" "directus_admin_password" {
  length  = 32
  special = true
}

resource "random_password" "directus_key" {
  length  = 64
  special = false
}

resource "random_password" "directus_secret" {
  length  = 32
  special = false
}

resource "random_password" "postgres_directus_password" {
  length  = 64
  special = true
}

resource "random_password" "api_db_password" {
  length  = 64
  special = true
}

resource "random_password" "builder_db_password" {
  length  = 64
  special = true
}

resource "random_password" "background_worker_db_password" {
  length  = 64
  special = true
}

resource "random_password" "unleash_db_password" {
  length  = 64
  special = true
}

resource "random_password" "onsite_backup_db_password" {
  length  = 64
  special = true
}

resource "random_password" "staging_sync_db_password" {
  length  = 64
  special = true
}

resource "random_password" "analytics_id_salt" {
  length  = 64
  special = true
}
