{{ config(severity='warn') }}

select
    order_id,
    order_amount,
    paid_amount,
    successful_payments_count
from {{ ref('fct_orders') }}
where is_confirmed
    and paid_amount > order_amount