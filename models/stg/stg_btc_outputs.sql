
{{
    config(
         materialized='incremental',
         incremental_strategy='append')

}}

{# unique_key='HASH_KEY',  no need to defined it as we are just appending rows#}

WITH flattened as (
SELECT 
tx.HASH_KEY,
tx.BLOCK_NUMBER,
tx.BLOCK_TIMESTAMP,
tx.IS_COINBASE,
f.value:address::STRING as OUTPUT_ADDRESS,
f.value:value::float as OUTPUT_VALUE
from {{ref("stg_btc")}} tx,
LATERAL FLATTEN(INPUT => OUTPUTS) f

where f.value:address is not null

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses >= to include records arriving later on the same day as the last run of this model)
  where tx.BLOCK_TIMESTAMP >= (select coalesce(max(BLOCK_TIMESTAMP), '1900-01-01') from {{ this }})

{% endif %}
) 
SELECT 
HASH_KEY,
BLOCK_NUMBER,
BLOCK_TIMESTAMP,
IS_COINBASE,
OUTPUT_ADDRESS,
OUTPUT_VALUE FROM flattened
