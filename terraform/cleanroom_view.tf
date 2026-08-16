resource "google_bigquery_dataset" "cleanroom_shared" {
  for_each   = var.clean_rooms
  project    = each.value.project_id
  dataset_id = "cleanroom_shared_${each.key}"
  location   = each.value.location
}

resource "null_resource" "cleanroom_view" {
  for_each = var.clean_rooms
  provisioner "local-exec" {
    command = <<-EOT
      bq query --project_id=${each.value.project_id} --use_legacy_sql=false \
      'CREATE OR REPLACE VIEW `${each.value.project_id}.${google_bigquery_dataset.cleanroom_shared[each.key].dataset_id}.shared_view`
       OPTIONS (
         privacy_policy = """{
           "aggregation_threshold_policy": {
             "threshold": ${each.value.aggregation_threshold},
             "privacy_unit_column": "${each.value.privacy_unit_col}"
           }
         }"""
       ) AS SELECT * FROM `${each.value.project_id}.${each.value.dataset_id}.${each.value.source_table}`'
    EOT
  }
  triggers = {
    threshold = each.value.aggregation_threshold
    dataset   = each.value.dataset_id
    table     = each.value.source_table
  }
}