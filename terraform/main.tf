terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.18.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "data_lake_bucket" {
  name     = var.gcs_bucket_name
  location = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}


resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id                 = var.bq_dataset_name
  location                   = var.region
  delete_contents_on_destroy = true
}