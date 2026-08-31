{{config(
    materialized ='ephemeral'
)}}

SELECT 
* 
FROM {{ref('stg_btc_outputs')}}

WHERE IS_COINBASE = false