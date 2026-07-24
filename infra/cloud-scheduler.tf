resource "google_cloud_scheduler_job" "refresh_views" {
  project     = google_project.brunstadtv.project_id
  name        = "refresh-views"
  description = "Refresh dependent materialized views in order (availability chain + filter_dataset)"
  schedule    = var.views_refresh_schedule
  region      = "europe-west1" // Cloud scheduler is not available in europe-west4

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-refresh-views",
      "source" : "cloudscheduler",
      "type" : "view.refresh",
      "datacontenttype" : "application/json",
      "data" : {
        "viewName" : "all",
        "force" : false
      }
    }))
  }

  retry_config {
    retry_count          = 0
    max_retry_duration   = "0s"
    min_backoff_duration = "5s"
    max_backoff_duration = "3600s"
    max_doublings        = 5
  }
}

resource "google_cloud_scheduler_job" "search_reindex" {
  project     = google_project.brunstadtv.project_id
  name        = "search-reindex"
  description = "Reindex all items for search"
  schedule    = var.search_reindex_schedule
  region      = "europe-west1" // Cloud scheduler is not available in europe-west4

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-2",
      "source" : "cloudscheduler",
      "type" : "search.reindex"
    }))
  }
}

resource "google_cloud_scheduler_job" "translations_sync" {
  project     = google_project.brunstadtv.project_id
  name        = "translations-sync"
  description = "Resync all translations"
  schedule    = var.translations_sync_schedule
  region      = "europe-west1" // Cloud scheduler is not available in europe-west4

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-3",
      "source" : "cloudscheduler",
      "type" : "translations.sync"
    }))
  }
}

resource "google_cloud_scheduler_job" "answers_sync" {
  project     = google_project.brunstadtv.project_id
  name        = "answers-sync"
  description = "Sync new answers to BQ"
  schedule    = var.answers_sync_schedule
  region      = "europe-west1" // Cloud scheduler is not available in europe-west4

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-4",
      "source" : "cloudscheduler",
      "type" : "statistics.exportanswers"
    }))
  }
}

resource "google_cloud_scheduler_job" "shorts_scores_sync" {
  project     = google_project.brunstadtv.project_id
  name        = "shorts-scores-sync"
  description = "Sync shorts scores BQ -> Postgres"
  schedule    = var.shorts_scores_sync_schedule
  region      = "europe-west1" // Cloud scheduler is not available in europe-west4

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-4",
      "source" : "cloudscheduler",
      "type" : "statistics.importshortsscores"
    }))
  }
}
