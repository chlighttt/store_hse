with orders as (
    select * from {{ ref('int_orders_with_payments') }}
    where is_confirmed
),

numbered as (
    select
        customer_id,
        order_id,
        ordered_at,
        order_amount,
        row_number() over (partition by customer_id order by ordered_at, order_id) as order_number
    from orders
)

select
    customer_id,
    count(*) as confirmed_orders_count,
    sum(order_amount) as confirmed_revenue,
    max(case when order_number = 1 then order_id end) as first_confirmed_order_id,
    min(ordered_at) as first_confirmed_at
from numbered
group by customer_id