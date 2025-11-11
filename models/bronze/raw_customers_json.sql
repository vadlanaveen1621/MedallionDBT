{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

SELECT 
    raw_json_data:customer_id::VARCHAR AS customer_id,
    raw_json_data AS customer_data,
    loaded_at
FROM {{ ref('stg_customers_json') }}
{% if is_incremental() %}
WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
{% endif %}
