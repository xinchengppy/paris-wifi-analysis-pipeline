from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col, to_timestamp, unix_timestamp, date_format,
    dayofweek, when, count, sum as _sum, avg, approx_count_distinct
)

spark = SparkSession.builder \
    .appName("WifiUsageSparkJob") \
    .getOrCreate()

# Read from GCS
df = spark.read \
    .option("header", True) \
    .option("sep", ";") \
    .csv("gs://paris-wifi-bucket/monthly/*.csv")

# Enrich with temporal and analytical features
df = df.withColumn("start_time", to_timestamp("date_heure_debut"))
df = df.withColumn("day", date_format("start_time", "yyyy-MM-dd"))
df = df.withColumn("weekday_name", date_format("start_time", "EEEE"))
df = df.withColumn("is_weekend", when(dayofweek("start_time").isin(1, 7), True).otherwise(False))
df = df.withColumn("district", col("code_postal").cast("string"))
df = df.withColumn("session_minutes", col("temps_de_sessions_en_minutes").cast("double"))

# Export cleaned enriched data
cleaned_path = "gs://paris-wifi-bucket/spark_output/cleaned"
df.coalesce(1) \
    .write \
    .option("header", True) \
    .option("sep", ";") \
    .option("escape", "\"") \
    .mode("overwrite") \
    .csv(cleaned_path)

# Filter out invalid postal codes
df_valid = df.filter(col("district").rlike(r"^\d{5}$"))

# Aggregation: per day per district
df_agg = df_valid.groupBy("day", "is_weekend", "weekday_name", "district").agg(
    count("*").alias("total_sessions"),
    _sum("session_minutes").alias("total_duration_minutes"),
    approx_count_distinct("code_site").alias("unique_sites"),
    avg("session_minutes").alias("average_duration_minutes")
)
df_agg = df_agg.withColumn("average_duration_minutes", col("average_duration_minutes").cast("float"))

# Export aggregated data
agg_path = "gs://paris-wifi-bucket/spark_output/agg"
df_agg.coalesce(1) \
    .write \
    .option("header", True) \
    .option("sep", ";") \
    .option("escape", "\"") \
    .mode("overwrite") \
    .csv(agg_path)

spark.stop()
