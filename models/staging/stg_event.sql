with source as (

    select * from {{ ref('gitbook-analytics.itw_test.user_event') }}

),

select
  user_id,
  event_name,
  event_datetime,
from source
