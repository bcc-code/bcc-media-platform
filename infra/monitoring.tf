resource "google_logging_metric" "errors_in_api" {
  count   = var.monitoring_enabled ? 1 : 0
  name    = "api/errors"
  project = google_project.brunstadtv.project_id
  filter  = "severity>=ERROR AND resource.labels.service_name=\"api-prod\""

  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    display_name = "Errors in log"
  }
}

# resource "google_monitoring_alert_policy" "api_errors_alert" {
#   count = var.monitoring_enabled ? 1 : 0
#   project      = google_project.brunstadtv.project_id
#   display_name = "API errors alert policy"
#   alert_strategy {
#     auto_close = "3600s"
#   }
#   combiner = "OR"
#   conditions {
#     display_name = "Errors too frequent"
#     condition_threshold {
#       filter          = "metric.type=\"logging.googleapis.com/user/api/errors\" AND resource.type=\"gce_instance\""
#       duration        = "0s"
#       threshold_value = 5
#       comparison      = "COMPARISON_GT"
#       aggregations {
#         alignment_period   = "60s"
#         per_series_aligner = "ALIGN_MAX"
#       }
#     }
#   }
#   lifecycle {
#     ignore_changes = ["notification_channels"]
#   }
# }
