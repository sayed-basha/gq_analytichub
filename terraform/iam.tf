locals {
  publisher_pairs = flatten([
    for room_key, room in var.clean_rooms : [
      for p in room.publishers : { key = "${room_key}__${p}", room = room_key, member = p }
    ]
  ])
  publisher_map = { for pr in local.publisher_pairs : pr.key => pr }

  subscriber_pairs = flatten([
    for room_key, room in var.clean_rooms : [
      for s in room.subscribers : { key = "${room_key}__${s}", room = room_key, member = s }
    ]
  ])
  subscriber_map = { for pr in local.subscriber_pairs : pr.key => pr }
}

resource "google_bigquery_analytics_hub_data_exchange_iam_member" "publisher" {
  for_each         = local.publisher_map
  project          = var.clean_rooms[each.value.room].project_id
  location         = var.clean_rooms[each.value.room].location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange[each.value.room].data_exchange_id
  role             = "roles/analyticshub.publisher"
  member           = each.value.member
}

resource "google_bigquery_analytics_hub_data_exchange_iam_member" "subscriber_exchange" {
  for_each         = local.subscriber_map
  project          = var.clean_rooms[each.value.room].project_id
  location         = var.clean_rooms[each.value.room].location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange[each.value.room].data_exchange_id
  role             = "roles/analyticshub.subscriber"
  member           = each.value.member
}

resource "google_bigquery_analytics_hub_listing_iam_member" "subscriber_listing" {
  for_each         = local.subscriber_map
  project          = var.clean_rooms[each.value.room].project_id
  location         = var.clean_rooms[each.value.room].location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.cleanroom_exchange[each.value.room].data_exchange_id
  listing_id       = google_bigquery_analytics_hub_listing.cleanroom_listing[each.value.room].listing_id
  role             = "roles/analyticshub.subscriber"
  member           = each.value.member
}