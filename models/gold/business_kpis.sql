{{
    config(
        materialized='table'
    )
}}

WITH daily_metrics AS (
    SELECT
        order_date,
        COUNT(*) AS order_count,
        SUM(amount) AS daily_revenue,
        COUNT(DISTINCT customer_key) AS daily_customers,
        AVG(amount) AS avg_order_value
    FROM {{ ref('fct_orders') }}
    WHERE status = 'COMPLETED'
    GROUP BY order_date
),

running_metrics AS (
    SELECT
        order_date,
        order_count,
        daily_revenue,
        daily_customers,
        avg_order_value,
        SUM(daily_revenue) OVER (ORDER BY order_date) AS cumulative_revenue,
        AVG(daily_revenue) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg_revenue
    FROM daily_metrics
)

SELECT * FROM running_metrics
