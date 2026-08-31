{% macro convert_to_usd(column_name) %}

{{column_name}} * (
    SELECT 
        price
         FROM {{ref('btc_usd_max')}}
    where  to_date(REPLACE(event_date,'UTC','')) = current_date()
    )

{% endmacro %}