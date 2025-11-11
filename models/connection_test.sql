{{
    config(
        materialized='table'
    )
}}

SELECT 
    'Connection successful' as status,
    CURRENT_DATABASE() as database,
    CURRENT_SCHEMA() as schema,
    CURRENT_TIMESTAMP() as test_time
