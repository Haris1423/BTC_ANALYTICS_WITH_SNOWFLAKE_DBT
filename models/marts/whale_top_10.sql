WITH BASE AS (
    SELECT 
    * 
    FROM

    {{ref('whale_alert')}}

    order by total_sent desc

    limit 10
)
select
* 
from 
base