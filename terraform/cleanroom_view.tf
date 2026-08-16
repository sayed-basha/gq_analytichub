# A dedicated dataset that holds the privacy-safe view (do not share the raw dataset directly)
resource "google_bigquery_dataset" "cleanroom_shared" {
  dataset_id = "cleanroom_shared"
  location   = var.location
}

resource "null_resource" "cleanroom_view" {
  provisioner "local-exec" {
    command = <<-EOT
      bq query --project_id=${var.project_id} --use_legacy_sql=false \
      'CREATE OR REPLACE VIEW `${var.project_id}.${google_bigquery_dataset.cleanroom_shared.dataset_id}.shared_view`
       OPTIONS (
         privacy_policy = """{
           "aggregation_threshold_policy": {
             "threshold": ${var.aggregation_threshold},
             "privacy_unit_column": "${var.privacy_unit_col}"
           }
         }"""
       ) AS SELECT * FROM `${var.project_id}.${var.dataset_id}.${var.source_table}`'
    EOT
  }
  triggers = { threshold = var.aggregation_threshold }
}