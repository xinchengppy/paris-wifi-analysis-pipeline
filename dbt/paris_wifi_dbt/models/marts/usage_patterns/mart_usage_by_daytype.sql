with source as (
    select 
        day,
        total_sessions,
        total_duration_minutes,
        weekday_name
    from {{ ref('stg_agg_wifi_usage_daily') }}
),

with_day_type as (
    select
        extract(year from day) as year,
        case
            when weekday_name in ('Monday', 'Tuesday', 'Wednesday', 'Thursday') then 'weekday'
            when weekday_name = 'Friday' then 'friday'
            when weekday_name in ('Saturday', 'Sunday') then 'weekend'
        end as day_type,
        total_sessions,
        total_duration_minutes
    from source
),

aggregated as (
    select
        year,
        day_type,
        count(*) as num_days,
        sum(total_sessions) as total_sessions,
        sum(total_duration_minutes) as total_duration_minutes,
        sum(total_sessions) / count(*) as avg_sessions_per_day,
        sum(total_duration_minutes) / count(*) as avg_duration_per_day,
        sum(total_duration_minutes) / sum(total_sessions) as avg_session_duration
    from with_day_type
    group by year, day_type
)

select * from aggregated