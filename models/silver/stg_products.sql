{{
    config(
        materialized='table'
    )
}}

SELECT
    {{ generate_surrogate_key(['product_id']) }} AS product_key,
    product_id,
    INITCAP(TRIM(product_name)) AS product_name,
    INITCAP(TRIM(category)) AS category,
    price,
    loaded_at
FROM {{ ref('raw_products_parquet') }}
WHERE product_id IS NOT NULL
  AND product_name IS NOT NULL
  AND price >= 0
