import pandas as pd
import os
import re
from unidecode import unidecode

# 1. Create output directory
os.makedirs("data/monthly", exist_ok=True)

# 2. Clean column names
def clean_col(col):
    col = unidecode(col)             
    col = col.lower().strip()
    col = col.replace(" ", "_").replace(".", "_")
    col = re.sub(r"[()]", "", col)
    col = re.sub(r"[^\w]", "", col)
    return col

# 3. Read CSV (semicolon separator)
df = pd.read_csv("data/paris_wifi_usage.csv", sep=";")

# 4. Clean column names
df.columns = [clean_col(col) for col in df.columns]

# 5. Convert datetime column
df["date_heure_debut"] = pd.to_datetime(df["date_heure_debut"], errors="coerce")
# Drop rows with invalid datetime
df = df.dropna(subset=["date_heure_debut"])

# 6. Add month column
df["month"] = df["date_heure_debut"].dt.to_period("M").astype(str)

# 7. Save each month to a separate CSV
for month in df["month"].unique():
    month_df = df[df["month"] == month].drop(columns=["month"])
    output_path = f"data/monthly/usage_{month}.csv"
    month_df.to_csv(output_path, sep=";", index=False)
    print(f"Saved: {output_path}")