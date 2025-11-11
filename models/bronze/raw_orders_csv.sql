{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

SELECT 
    order_id::VARCHAR AS order_id,
    customer_id::VARCHAR AS customer_id,
    TRY_TO_DATE(order_date) AS order_date,
    amount::DECIMAL(10,2) AS amount,
    status::VARCHAR AS status,
    loaded_at
FROM {{ ref('stg_orders_csv') }}
{% if is_incremental() %}
WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
{% endif %}
