WITH  WHALES AS (
SELECT 
output_address,
sum(output_value) as total_sent,
count(*) as tx_count

FROM {{ref('stg_btc_transactions')}}

where output_value > 10

group by output_address
order by total_sent desc
)

SELECT 
'{{ invocation_id }}' as invocation_id,
W.output_address,
W.total_sent,
W.tx_count,
{{convert_to_usd('W.total_sent')}} AS total_sent_usd
 FROM WHALES  W

 order by total_sent desc