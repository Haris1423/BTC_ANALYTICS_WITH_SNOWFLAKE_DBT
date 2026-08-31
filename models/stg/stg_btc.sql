{{config(
    materialized='incremental',
    unique_key='HASH_KEY',
    incremental_strategy='merge',


)}}

SELECT 
* 
FROM 

{{source('btc','btc')}}


{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses >= to include records arriving later on the same day as the last run of this model)
  where BLOCK_TIMESTAMP >= (select coalesce(max(BLOCK_TIMESTAMP), '1900-01-01') from {{ this }})

{% endif %}