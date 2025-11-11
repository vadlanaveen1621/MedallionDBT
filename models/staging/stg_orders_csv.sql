{{
    config(
        materialized='view'
    )
}}

SELECT 
    order_id,
    customer_id,
    order_date,
    amount,
    status,
    CURRENT_TIMESTAMP() AS loaded_at
FROM {{ source('raw', 'orders_csv') }}
