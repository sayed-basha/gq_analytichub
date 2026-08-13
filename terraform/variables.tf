variable "project_id"        { type = string }
#variable "location"          { type = string, default = "asia-southeast1"}
variable "location" {
  type    = string
  default = "asia-southeast1"
}
variable "dataset_id"        { type = string }            # your existing BQ dataset
variable "source_table"      { type = string }            # table inside that dataset to share
variable "privacy_unit_col"  { type = string }            # e.g. "customer_id"

# This is the user-facing knob: the threshold value
variable "aggregation_threshold" {
  type        = number
  default     = 100
  description = "Minimum distinct privacy-unit count required per output row before results are returned to a subscriber."
}

# --- Publisher / Subscriber (the two core Analytics Hub / Clean Room identities) ---

variable "publishers" {
  type        = list(string)
  default     = []
  description = "Principals allowed to create/manage listings in the exchange, e.g. [\"user:alice@company.com\", \"group:data-eng@company.com\", \"serviceAccount:sa@project.iam.gserviceaccount.com\"]"
}

variable "subscribers" {
  type        = list(string)
  default     = []
  description = "Principals allowed to subscribe to the clean room / listing, same format as publishers. This is the other org / team you're sharing data with."
}