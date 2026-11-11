{{ config(distributed_replicated=true) }}

with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2026-01-01' as date)",
        end_date="cast('2027-01-01' as date)"
    ) }}
),

orders as (
    select * from {{ ref('stg_shop__orders') }}
),

borders as (
    select
        min(order_date) as first_date,
        max(order_date) as last_date
    from orders
),

days as (
    select cast(s.date_day as date) as date_day
    from spine as s
    cross join borders as b
    where s.date_day >= b.first_date
        and s.date_day <= b.last_date
)

select
    date_day,
    cast(extract(year from date_day) as integer) as year,
    cast(extract(quarter from date_day) as integer) as quarter,
    cast(extract(month from date_day) as integer) as month,
    cast(date_trunc('month', date_day) as date) as month_start,
    cast(extract(isodow from date_day) as integer) as day_of_week,
    extract(isodow from date_day) in (6, 7) as is_weekend
from days