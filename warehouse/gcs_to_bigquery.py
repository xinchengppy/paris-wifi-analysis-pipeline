from google.cloud import bigquery

# GCP configuration
project_id = "round-fold-449120-g9"
dataset_id = "paris_wifi_dataset"
bucket_name = "paris-wifi-bucket"

tables = {
    "wifi_usage_cleaned": "spark_output/cleaned/*.csv",
    "agg_wifi_usage_daily": "spark_output/agg/*.csv",
    "wifi_sites_available": "paris_wifi_sites_available.csv"
}

# Initialize client
client = bigquery.Client(project=project_id)

for table_name, gcs_path in tables.items():
    table_ref = f"{project_id}.{dataset_id}.{table_name}"
    uri = f"gs://{bucket_name}/{gcs_path}"

    external_config = bigquery.ExternalConfig("CSV")
    external_config.source_uris = [uri]
    external_config.options.skip_leading_rows = 1
    external_config.options.field_delimiter = ";"
    external_config.options.quote_character = '"'
    external_config.autodetect = True

    table = bigquery.Table(table_ref)
    table.external_data_configuration = external_config

    try:
        client.delete_table(table_ref, not_found_ok=True)
        client.create_table(table)
        print(f"Created external table: {table_ref}")
    except Exception as e:
        print(f"Failed to create table {table_name}: {e}")