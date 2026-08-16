resource "google_bigquery_analytics_hub_listing" "cleanroom_listing" {
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange.data_exchange_id
  listing_id       = "cleanroom_listing"
  display_name     = "Shared Clean Room Data"

  bigquery_dataset {
    dataset = "projects/${var.project_id}/datasets/${google_bigquery_dataset.cleanroom_shared.dataset_id}"
    selected_resources {
      table = "projects/${var.project_id}/datasets/${google_bigquery_dataset.cleanroom_shared.dataset_id}/tables/shared_view"
    }
  }

  restricted_export_config {
    enabled               = true
    restrict_query_result = true
  }

  depends_on = [null_resource.cleanroom_view]
}