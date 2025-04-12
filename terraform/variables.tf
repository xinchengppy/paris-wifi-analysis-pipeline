variable "project" {
  description = "GCP project ID"
  type        = string
  default     = "round-fold-449120-g9"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "gcs_bucket_name" {
  description = "Name of GCS bucket"
  type        = string
  default     = "paris-wifi-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  type        = string
  default     = "paris_wifi_dataset"
}