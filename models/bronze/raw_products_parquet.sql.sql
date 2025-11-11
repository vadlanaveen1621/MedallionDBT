{{
    config(
        materialized='incremental',
        unique_key='product_id'
    )
}}

SELECT 
    product_id::VARCHAR AS product_id,
    product_name::VARCHAR AS product_name,
    category::VARCHAR AS category,
    price::DECIMAL(10,2) AS price,
    loaded_at
FROM {{ ref('stg_products_parquet') }}
{% if is_incremental() %}
WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
{% endif %}
