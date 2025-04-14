-- models/staging/stg_agg_wifi_usage_daily.sql

with source as (
    select * from {{ source('paris_wifi_dataset', 'agg_wifi_usage_daily') }}
),

renamed as (
    select
        day,
        is_weekend,
        weekday_name,
        CAST(district as STRING) as district,
        total_sessions,
        total_duration_minutes,
        unique_sites,
        average_duration_minutes
    from source
)

select * from renamed