with usage as (
    select
        district,
        total_sessions,
        total_duration_minutes
    from {{ ref('stg_agg_wifi_usage_daily') }}
),

-- Aggregate sessions and durations by district
agg_usage as (
    select
        district,
        count(*) as num_days,
        sum(total_sessions) as total_sessions,
        sum(total_duration_minutes) as total_duration_minutes,
        sum(total_sessions) * 1.0 / count(*) as avg_sessions_per_day,
        sum(total_duration_minutes) * 1.0 / count(*) as avg_minutes_per_day
    from usage
    group by district
),

-- Get number of available wifi sites in each district
site_info as (
    select
        district,
        count(*) as total_sites
    from {{ ref('stg_wifi_sites_available') }}
    group by district
),

-- Join usage stats with site metadata
joined as (
    select
        u.district,
        u.num_days,
        u.total_sessions,
        u.total_duration_minutes,
        s.total_sites,
        u.avg_sessions_per_day,
        u.avg_minutes_per_day,
        -- Utilization: daily sessions per site
        round(u.avg_sessions_per_day / s.total_sites, 2) as avg_sessions_per_site_per_day,
        round(u.avg_minutes_per_day / s.total_sites, 2) as avg_minutes_per_site_per_day
    from agg_usage u
    join site_info s
      on u.district = s.district
)

select * from joined