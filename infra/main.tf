locals {
  aws_region = "eu-north-1"
}

terraform {
  required_providers {
    # Non-hashicorp providers are not implicitly resolvable and must be declared.
    ioriver = {
      source  = "ioriver/ioriver"
      version = "~> 1.4"
    }
  }
}

provider "aws" {
  region  = local.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile
}

provider "google" {
  //project = var.project
  region = var.gcp-region
}

provider "google-beta" {
  region = var.gcp-region
}

# DNS zones live in their own project (see the private infra repo's
# projects/global/dns), so cross-project record sets need a dedicated provider.
provider "google" {
  alias   = "dns"
  project = var.dns_project
  region  = var.gcp-region
}

# Live-CDN ioriver account (separate account from the dashboard-managed VOD
# one). The token is empty in envs where var.live_cdn is null — the provider
# does not validate it until a resource actually calls the API.
provider "ioriver" {
  token = var.ioriver_live_token
}

module "vod_cdn" {
  source               = "./vod-cdn"
  env                  = var.env
  basepath             = var.basepath
  mediapackage_url     = var.mediapackage_url
  public_keys          = var.vod_cdn_public_keys
  custom_domain        = var.vod_cloudfront_domain
  files_custom_domain  = "files.${var.base_platform_domain}"
  download_az_domain   = "test.example.brunstad.tv" // TODO: This is not correct yet
  download_s3_domain   = aws_s3_bucket.vod-asset-storage-bucket.bucket_regional_domain_name
  legacy_cdn_domain    = "vod.brunstad.tv"
  custom_domain_legacy = var.legacy_cdn_domain
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

// Note: For debugging you can manually add a url from https://webhook.site or an NGROK url (for local testing)
// directly in the AWS console. A copy of the event will be sent to each target:
// Direct URL for DEV: https://eu-north-1.console.aws.amazon.com/sns/v3/home?region=eu-north-1#/topic/arn:aws:sns:eu-north-1:742348992291:vod-events-dev-eventbridge:w
module "vod-events" {
  source = "./aws-eventsbridge-to-url"
  env    = var.env
  name   = "vod-events"
  target = "${google_cloud_run_service.background_worker.status[0].url}/api/aws"
}

module "redis" {
  source  = "./redis"
  count   = var.redis_enable ? 1 : 0
  project = google_project.brunstadtv.project_id
  region  = var.gcp-region
}

module "unleash" {
  source                   = "./unleash"
  project                  = google_project.brunstadtv.project_id
  region                   = var.gcp-region
  env                      = var.env
  dbname                   = google_sql_database.unleash.name
  dbconnname               = google_sql_database_instance.main.connection_name
  dbuser                   = google_sql_user.unleash.name
  dbpass                   = random_password.unleash_db_password.result
  unleash_url              = var.unleash_url
  unleash_proxy_client_key = var.unleash_proxy_client_key
  unleash_api_token        = var.unleash_api_token
  run_env                  = {}
}

module "imgx_cdn" {
  source          = "./imgix-cdn"
  count           = var.imgix_cdn_enable ? 1 : 0
  backend-domain  = var.imgix_backend_domain
  frontend-domain = var.imgix_frontend_domain
  providers = {
    aws.main      = aws
    aws.us_east_1 = aws.us_east_1
  }
}

