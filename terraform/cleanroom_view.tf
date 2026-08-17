resource "null_resource" "cleanroom_view" {
  for_each = var.clean_rooms
  provisioner "local-exec" {
    command = <<-EOT
      bq query --project_id=${each.value.project_id} --use_legacy_sql=false \
      'CREATE OR REPLACE VIEW `${each.value.project_id}.${each.value.dataset_id}.cleanroom_view_${each.key}`
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
    threshold  = each.value.aggregation_threshold
    dataset    = each.value.dataset_id
    table      = each.value.source_table
    query_hash = sha1("${each.value.project_id}${each.value.dataset_id}${each.key}${each.value.source_table}${each.value.privacy_unit_col}${each.value.aggregation_threshold}")
  }
}