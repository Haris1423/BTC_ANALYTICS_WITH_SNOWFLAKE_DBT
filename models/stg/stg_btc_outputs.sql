{{ 
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH flattened AS (

    SELECT 
        tx.HASH_KEY,
        tx.BLOCK_NUMBER,
        tx.BLOCK_TIMESTAMP,
        tx.IS_COINBASE,
        f.value:address::STRING AS OUTPUT_ADDRESS,
        f.value:value::FLOAT AS OUTPUT_VALUE

    FROM {{ ref("stg_btc") }} tx,
    LATERAL FLATTEN(INPUT => OUTPUTS) f

    WHERE f.value:address IS NOT NULL

    {% if is_incremental() %}

        AND tx.BLOCK_TIMESTAMP >= (
            SELECT COALESCE(
                MAX(BLOCK_TIMESTAMP),
                '1900-01-01'
            )
            FROM {{ this }}
        )

    {% endif %}

)

SELECT 
    HASH_KEY,
    BLOCK_NUMBER,
    BLOCK_TIMESTAMP,
    IS_COINBASE,
    OUTPUT_ADDRESS,
    OUTPUT_VALUE

FROM flattened