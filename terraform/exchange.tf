resource "google_bigquery_analytics_hub_data_exchange" "cleanroom_exchange" {
  location         = var.location
  data_exchange_id = "cleanroom_exchange"
  display_name     = "Clean Room Exchange"
  description      = "Data clean room for privacy-safe sharing"

  sharing_environment_config {
    dcr_exchange_config {}   # <-- this flag is what makes it a Clean Room, not a plain exchange
  }
}