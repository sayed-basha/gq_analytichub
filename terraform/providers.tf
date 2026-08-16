provider "google" {
  # No default project/region here — every resource in this repo sets its own
  # `project` (and `location`) explicitly per clean room, since a single run
  # can now manage clean rooms across multiple projects/regions.
}