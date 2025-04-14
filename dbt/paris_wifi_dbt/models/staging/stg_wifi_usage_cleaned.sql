-- models/staging/stg_wifi_usage_cleaned.sql

with source as (
    select * from `round-fold-449120-g9.paris_wifi_dataset.wifi_usage_cleaned`
),

renamed as (
    select
        day,
        is_weekend,
        weekday_name,
        district,
        code_site as site_code,
        session_minutes,
        nom_du_site as site_name,
        start_time,
        type_dappareil as device_type,
        langue_utilisateur as system_language,
    from source
)

select * from renamed