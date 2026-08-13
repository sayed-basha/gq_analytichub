# --- Publisher: can create/update/delete listings inside this exchange ---
resource "google_bigquery_analytics_hub_data_exchange_iam_member" "publisher" {
  for_each         = toset(var.publishers)
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange.data_exchange_id
  role             = "roles/analyticshub.publisher"
  member           = each.value
}

# --- Subscriber granted at the EXCHANGE level ---
# Required for data clean rooms specifically: the subscriber accepts the whole
# clean room exchange (not just one listing) so they can run governed queries.
resource "google_bigquery_analytics_hub_data_exchange_iam_member" "subscriber_exchange" {
  for_each         = toset(var.subscribers)
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange.data_exchange_id
  role             = "roles/analyticshub.subscriber"
  member           = each.value
}

# --- Subscriber granted at the LISTING level ---
# Use this instead of (or in addition to) the exchange-level grant when you want
# to give a subscriber access to just one listing rather than the whole clean room.
resource "google_bigquery_analytics_hub_listing_iam_member" "subscriber_listing" {
  for_each         = toset(var.subscribers)
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange.data_exchange_id
  listing_id       = google_bigquery_analytics_hub_listing.cleanroom_listing.listing_id
  role             = "roles/analyticshub.subscriber"
  member           = each.value
}