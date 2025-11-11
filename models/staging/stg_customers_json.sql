{{
    config(
        materialized='view'
    )
}}

SELECT 
    src AS raw_json_data,
    CURRENT_TIMESTAMP() AS loaded_at
FROM {{ source('raw', 'customers_json') }}
