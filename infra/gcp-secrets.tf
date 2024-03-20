module "background_worker_secrets" {
  source  = "./gcp-secrets"
  project = google_project.brunstadtv.project_id
  secrets = merge(var.background_worker_secrets,
    {
      AWS_ACCESS_KEY_ID = {
        data = aws_iam_access_key.backgroundjobs.id
        name = "AWS_ACCESS_KEY_ID"
      },
      AWS_SECRET_ACCESS_KEY = {
        data = aws_iam_access_key.backgroundjobs.secret
        name = "AWS_SECRET_ACCESS_KEY"
      },
      postgres_background_worker_password = {
        name = "PGPASSWORD"
        data = random_password.background_worker_db_password.result
      },
  })
  secret_accessors = ["serviceAccount:${google_service_account.background_worker.email}"]
}

module "builder_secrets" {
  source = "./gcp-secrets"
  secrets = {
    postgres_builder_password = {
      name = "PGPASSWORD"
      data = random_password.builder_db_password.result
    },
  }
  project = google_project.brunstadtv.project_id
  secret_accessors = [
    "serviceAccount:${google_project_service_identity.cloudbuils_sa.email}",
  ]
}

module "staging_sync_secrets" {
  source = "./gcp-secrets"
  secrets = {
    postgres_staging_sync_password = {
      name = "PGPASSWORD"
      data = random_password.staging_sync_db_password.result
    },
  }
  project = google_project.brunstadtv.project_id
  secret_accessors = []
}

module "directus_secrets" {
  source = "./gcp-secrets"
  secrets = merge(var.directus_secrets,
    { directus_admin_password = {
      name = "ADMIN_PASSWORD"
      data = random_password.directus_admin_password.result
      },
      directus_key = {
        name = "KEY"
        data = random_password.directus_key.result
      },
      directus_secret = {
        name = "SECRET"
        data = random_password.directus_secret.result
      },
      postgres_directus_password = {
        name = "PGPASSWORD"
        data = random_password.postgres_directus_password.result
      },
    }
  )
  project          = google_project.brunstadtv.project_id
  secret_accessors = ["serviceAccount:${google_service_account.directus.email}"]
}

module "api_secrets" {
  source  = "./gcp-secrets"
  project = google_project.brunstadtv.project_id
  secrets = merge(var.api_secrets,
    { postgres_api_password = {
      name = "PGPASSWORD"
      data = random_password.api_db_password.result
      },
      AWS_ACCESS_KEY_ID_API = {
        data = aws_iam_access_key.api.id
        name = "AWS_ACCESS_KEY_ID"
      },
      AWS_SECRET_ACCESS_KEY_API = {
        data = aws_iam_access_key.api.secret
        name = "AWS_SECRET_ACCESS_KEY"
      },
      REDIRECT_JWT_KEY = {
        data = tls_private_key.redirect.private_key_pem
        name = "REDIRECT_JWT_KEY"
      },
      REDIRECT_JWT_KEY_ID = {
        data = tls_private_key.redirect.id
        name = "REDIRECT_JWT_KEY_ID"
      },
      ANALYTICS_SALT = {
        data = random_password.analytics_id_salt.result
        name = "ANALYTICS_SALT"
      },
    }
  )
  secret_accessors = ["serviceAccount:${google_service_account.api.email}"]
}

module "api_secret_files" {
  source  = "./gcp-secrets"
  project = google_project.brunstadtv.project_id
  secrets = {
    for k, v in var.api_secret_files : k => {
      name = v.mount_point
      data = file("${var.basepath}/${v.local_path}")
    }
  }
  secret_accessors = ["serviceAccount:${google_service_account.api.email}"]
}

module "web_deploy_secrets" {
  source  = "./gcp-secrets"
  project = google_project.brunstadtv.project_id
  secrets = {
    npaw_account_code = {
      name = "NPAW_ACCOUNT_CODE"
      data = var.npaw_account_code
    }
    rudderstack_write_key = {
      name = "RUDDERSTACK_WRITE_KEY"
      data = var.rudderstack_write_key
    }
    rudderstack_data_plane_url = {
      name = "RUDDERSTACK_DATA_PLANE_URL"
      data = var.rudderstack_data_plane_url
    }
  }
  secret_accessors = ["serviceAccount:${var.semaphore_service_account}"]
}
