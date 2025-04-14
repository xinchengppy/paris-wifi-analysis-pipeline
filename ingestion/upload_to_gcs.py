from google.cloud import storage
import os

# Set your GCS bucket name
BUCKET_NAME = "paris-wifi-bucket"

# Create GCS client
client = storage.Client()
bucket = client.bucket(BUCKET_NAME)

# 1. Upload sites data
sites_path = "data/paris_wifi_sites_available.csv"
blob = bucket.blob("data/paris_wifi_sites_available.csv")
blob.upload_from_filename(sites_path)

# 2. Upload monthly split usage data
monthly_dir = "data/monthly"
for filename in os.listdir(monthly_dir):
    if filename.endswith(".csv"):
        local_path = os.path.join(monthly_dir, filename)
        gcs_path = f"monthly/{filename}"
        blob = bucket.blob(gcs_path)
        blob.upload_from_filename(local_path)