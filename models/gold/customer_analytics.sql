{{
    config(
        materialized='table'
    )
}}

WITH customer_orders AS (
    SELECT
        customer_key,
        COUNT(*) AS total_orders,
        SUM(amount) AS total_spent,
        AVG(amount) AS avg_order_value,
        MAX(order_date) AS last_order_date
    FROM {{ ref('fct_orders') }}
    WHERE status = 'COMPLETED'
    GROUP BY customer_key
),

customer_segmentation AS (
    SELECT
        co.customer_key,
        c.first_name,
        c.last_name,
        c.email,
        co.total_orders,
        co.total_spent,
        co.avg_order_value,
        co.last_order_date,
        CASE
            WHEN co.total_spent >= 1000 THEN 'VIP'
            WHEN co.total_spent >= 500 THEN 'Premium'
            WHEN co.total_spent >= 100 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment,
        CASE
            WHEN DATEDIFF('day', co.last_order_date, CURRENT_DATE()) <= 30 THEN 'Active'
            WHEN DATEDIFF('day', co.last_order_date, CURRENT_DATE()) <= 90 THEN 'Inactive'
            ELSE 'Churned'
        END AS customer_status
    FROM customer_orders co
    JOIN {{ ref('dim_customers') }} c
        ON co.customer_key = c.customer_key
)

SELECT * FROM customer_segmentation
