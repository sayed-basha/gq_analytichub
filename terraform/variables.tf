variable "clean_rooms" {
  description = "Map of clean rooms to create. Key = unique clean room name (e.g. 'patient_data')."
  type = map(object({
    project_id            = string
    location              = string
    dataset_id            = string
    source_table          = string
    privacy_unit_col      = string
    aggregation_threshold = number
    publishers            = list(string)
    subscribers           = list(string)
  }))
  default = {}
}