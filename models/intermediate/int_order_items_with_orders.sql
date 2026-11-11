with order_items as (
    select * from {{ ref('stg_shop__order_items') }}
),

orders as (
    select * from {{ ref('int_orders_with_payments') }}
)

select
    i.order_item_id,
    i.order_id,
    i.product_id,
    o.customer_id,
    o.order_date,
    i.quantity,
    i.unit_price,
    i.discount_amount,
    i.line_amount,
    o.is_confirmed,
    o.is_test_order
from order_items as i
join orders as o
    on o.order_id = i.order_id