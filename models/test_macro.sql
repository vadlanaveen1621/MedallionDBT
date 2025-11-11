{{
    config(
        materialized='table'
    )
}}

SELECT
    {{ generate_surrogate_key('1') }} as test_key_1,
    {{ generate_surrogate_key("'hello'") }} as test_key_2,
    {{ generate_surrogate_key(["1", "'world'"]) }} as test_key_3,
    {{ generate_surrogate_key(["'test'", "'composite'", "'key'"]) }} as test_key_4
