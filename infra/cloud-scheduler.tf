resource "google_cloud_scheduler_job" "refresh_filter_dataset" {
  project     = google_project.brunstadtv.project_id
  name        = "refresh-filter-dataset"
  description = "Pings the episode access view to refresh it"
  schedule    = var.views_refresh_schedule
  region      = "europe-west1" // Cloud scheduler is not available in europe-west4

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-1",
      "source" : "cloudscheduler",
      "type" : "view.refresh",
      "datacontenttype" : "application/json",
      "data" : {
        "viewName" : "filter_dataset",
        "force" : false
      }
    }))
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

resource "google_cloud_scheduler_job" "refresh_episode_availability" {
  project     = google_project.brunstadtv.project_id
  name        = "refresh-episode-availability"
  description = "Refresh the episode_availability materialized view"
  schedule    = var.views_refresh_schedule
  region      = "europe-west1"

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-episode-availability",
      "source" : "cloudscheduler",
      "type" : "view.refresh",
      "datacontenttype" : "application/json",
      "data" : {
        "viewName" : "episode_availability",
        "force" : false
      }
    }))
  }
}

resource "google_cloud_scheduler_job" "refresh_season_availability" {
  project     = google_project.brunstadtv.project_id
  name        = "refresh-season-availability"
  description = "Refresh the season_availability materialized view"
  schedule    = var.views_refresh_schedule
  region      = "europe-west1"

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-season-availability",
      "source" : "cloudscheduler",
      "type" : "view.refresh",
      "datacontenttype" : "application/json",
      "data" : {
        "viewName" : "season_availability",
        "force" : false
      }
    }))
  }
}

resource "google_cloud_scheduler_job" "refresh_show_availability" {
  project     = google_project.brunstadtv.project_id
  name        = "refresh-show-availability"
  description = "Refresh the show_availability materialized view"
  schedule    = var.views_refresh_schedule
  region      = "europe-west1"

  pubsub_target {
    topic_name = google_pubsub_topic.background_worker.id
    data = base64encode(jsonencode({
      "specversion" : "1.0",
      "id" : "cloudscheduler-show-availability",
      "source" : "cloudscheduler",
      "type" : "view.refresh",
      "datacontenttype" : "application/json",
      "data" : {
        "viewName" : "show_availability",
        "force" : false
      }
    }))
  }
}
