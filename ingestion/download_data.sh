#!/bin/bash

# Download paris wifi utilisation data
wget -O data/paris_wifi_usage.csv "https://www.data.gouv.fr/fr/datasets/r/75e68d86-6718-451d-9713-6f986e258bb1"

# Download paris wifi site info data
wget -O data/paris_wifi_sites_available.csv "https://www.data.gouv.fr/fr/datasets/r/efcdbab7-e836-4149-9f91-40696e414a2e"

echo "Download completed."