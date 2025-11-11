{% macro generate_surrogate_key(field_list) %}
    {%- if field_list is string -%}
        {%- set fields = [field_list] -%}
    {%- else -%}
        {%- set fields = field_list -%}
    {%- endif -%}
    
    {%- set field_expressions = [] -%}
    
    {%- for field in fields -%}
        {%- set field_expression = "coalesce(cast(" ~ field ~ " as varchar), '')" -%}
        {%- do field_expressions.append(field_expression) -%}
    {%- endfor -%}
    
    {%- if field_expressions | length == 1 -%}
        md5({{ field_expressions[0] }})
    {%- else -%}
        md5(concat({{ field_expressions | join(', ') }}))
    {%- endif -%}
{% endmacro %}
