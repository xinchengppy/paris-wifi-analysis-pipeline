with source as (
    select
        extract(year from day) as year,
        system_language,
        count(*) as session_count
    from {{ ref('stg_wifi_usage_cleaned') }}
    where system_language is not null
    group by year, system_language
),

total_per_year as (
    select
        year,
        sum(session_count) as total_sessions
    from source
    group by year
),

with_share as (
    select
        s.year,
        s.system_language,
        s.session_count,
        t.total_sessions,
        round(s.session_count * 100.0 / t.total_sessions, 2) as share_percent
    from source s
    join total_per_year t
      on s.year = t.year
)

select * from with_share
order by year, share_percent desc