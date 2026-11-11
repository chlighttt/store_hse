with paid_orders as (
    select distinct order_id
    from {{ source('shop', 'payments') }}
    where payment_status = 'success'
        and amount > 0
),

source_total as (
    select coalesce(sum(o.total_amount), 0) as source_revenue
    from {{ source('shop', 'orders') }} as o
    join paid_orders as p
        on p.order_id = o.order_id
    where o.status = 'paid'
),

mart_total as (
    select coalesce(sum(order_amount), 0) as mart_revenue
    from {{ ref('fct_orders') }}
    where is_confirmed
)

select
    s.source_revenue,
    m.mart_revenue
from source_total as s
cross join mart_total as m
where s.source_revenue <> m.mart_revenue