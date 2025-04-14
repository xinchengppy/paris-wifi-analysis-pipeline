with base as (

    select
        extract(year from day) as year,
        district,
        sum(total_sessions) as total_sessions,
        sum(total_duration_minutes) as total_duration_minutes,
        sum(total_duration_minutes) / sum(total_sessions) as average_duration_minutes,
        approx_count_distinct(district || '-' || day || '-' || cast(unique_sites as string)) as unique_sites
    from {{ ref('stg_agg_wifi_usage_daily') }}
    group by year, district

)

select * from base