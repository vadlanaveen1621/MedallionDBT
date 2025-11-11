{{
    config(
        materialized='table'
    )
}}

WITH customer_json_data AS (
    SELECT
        customer_id,
        customer_data:first_name::VARCHAR AS first_name,
        customer_data:last_name::VARCHAR AS last_name,
        customer_data:email::VARCHAR AS email,
        customer_data:phone::VARCHAR AS phone,
        customer_data:address:street::VARCHAR AS street,
        customer_data:address:city::VARCHAR AS city,
        customer_data:address:state::VARCHAR AS state,
        customer_data:address:zip_code::VARCHAR AS zip_code,
        loaded_at
    FROM {{ ref('raw_customers_json') }}
),

customer_cleaned AS (
    SELECT
        {{ generate_surrogate_key(['customer_id']) }} AS customer_key,
        customer_id,
        INITCAP(TRIM(first_name)) AS first_name,
        INITCAP(TRIM(last_name)) AS last_name,
        LOWER(TRIM(email)) AS email,
        REGEXP_REPLACE(phone, '[^0-9]', '') AS phone,
        INITCAP(TRIM(street)) AS street,
        INITCAP(TRIM(city)) AS city,
        UPPER(TRIM(state)) AS state,
        zip_code,
        loaded_at
    FROM customer_json_data
    WHERE email IS NOT NULL
      AND customer_id IS NOT NULL
)

SELECT * FROM customer_cleaned
