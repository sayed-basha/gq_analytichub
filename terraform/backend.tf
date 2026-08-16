terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
  backend "gcs" {
    bucket = "project-33186132-7866-4181-982-tfstate"
    prefix = "analytics-hub"
  }
}