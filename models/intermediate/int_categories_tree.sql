with recursive categories as (
    select * from {{ ref('stg_shop__product_categories') }}
),

tree as (
    select
        category_id,
        category_name,
        parent_category_id,
        category_name as root_category_name,
        1 as category_level
    from categories
    where parent_category_id is null

    union all

    select
        c.category_id,
        c.category_name,
        c.parent_category_id,
        t.root_category_name,
        t.category_level + 1 as category_level
    from categories as c
    join tree as t
        on c.parent_category_id = t.category_id
)

select
    t.category_id,
    t.category_name,
    p.category_name as parent_category_name,
    t.root_category_name,
    t.category_level
from tree as t
left join categories as p
    on p.category_id = t.parent_category_id