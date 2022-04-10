{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ adapter_macro('dbt_utils.dateadd', datepart, interval, from_date_or_timestamp) }}
{% endmacro %}

with last_30_days_events as (

    select * 
    from {{ ref('stg_event') }} 
    where dbt_utils.dateadd(day, 30, event_datetime),
  
  
pivot_events as (
  select
   user_id,
   {{ dbt_utils.pivot('event_name', dbt_utils.get_column_values(ref('last_30_days_events'), count('event_name'), max(event_datetime))) }}
from {{ ref('last_30_days_events') }} 
group by user_id

)

select * from pivot_events
