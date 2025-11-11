{{
    config(
        materialized='table'
    )
}}
WITH orders_cleaned AS (
    SELECT
        {{ generate_surrogate_key(['order_id']) }} AS order_key,
        order_id,
        customer_id,
        order_date,
        amount,
        UPPER(TRIM(status)) AS status,
        loaded_at
    FROM {{ ref('raw_orders_csv') }}
    WHERE order_id IS NOT NULL
      AND customer_id IS NOT NULL
      AND order_date IS NOT NULL
      AND amount > 0
),

orders_with_customer AS (
    SELECT
        o.order_key,
        o.order_id,
        c.customer_key,
        o.order_date,
        o.amount,
        o.status,
        o.loaded_at
    FROM orders_cleaned o
    LEFT JOIN {{ ref('dim_customers') }} c
        ON o.customer_id = c.customer_id
)

SELECT * FROM orders_with_customer
