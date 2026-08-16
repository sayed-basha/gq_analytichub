resource "google_bigquery_analytics_hub_data_exchange" "cleanroom_exchange" {
  for_each          = var.clean_rooms
  project           = each.value.project_id
  location          = each.value.location
  data_exchange_id  = "cleanroom_${each.key}"
  display_name      = "Clean Room - ${each.key}"
  description       = "Data clean room for ${each.key}"

  sharing_environment_config {
    dcr_exchange_config {}
  }
}