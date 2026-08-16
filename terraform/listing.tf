resource "google_bigquery_analytics_hub_listing" "cleanroom_listing" {
  for_each         = var.clean_rooms
  project          = each.value.project_id
  location         = each.value.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange[each.key].data_exchange_id
  listing_id       = "listing_${each.key}"
  display_name     = "Shared Data - ${each.key}"

  bigquery_dataset {
    dataset = "projects/${each.value.project_id}/datasets/${each.value.dataset_id}"
    selected_resources {
      table = "projects/${each.value.project_id}/datasets/${each.value.dataset_id}/tables/cleanroom_view_${each.key}"
    }
  }

  restricted_export_config {
    enabled               = true
    restrict_query_result = true
  }

  depends_on = [null_resource.cleanroom_view]
}