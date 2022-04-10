{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ adapter_macro('dbt_utils.dateadd', datepart, interval, from_date_or_timestamp) }}
{% endmacro %}

{% macro pivot_event_name(column,
               values,
               alias=True,
               agg='count',
               cmp='=',
               prefix='',
               suffix='_count',
               then_value=1,
               else_value=0,
               quote_identifiers=True,
               distinct=False) %}
    {{ return(adapter.dispatch('pivot', 'dbt_utils')(column, values, alias, agg, cmp, prefix, suffix, then_value, else_value, quote_identifiers, distinct)) }}
{% endmacro %}

-- {% macro pivot_event_name(column,
--                values,
--                alias=True,
--                agg='max',
--                cmp='=',
--                prefix='',
--                suffix='_last_date',
--                then_value=1,
--                else_value=0,
--                quote_identifiers=True,
--                distinct=False) %}
--     {{ return(adapter.dispatch('pivot', 'dbt_utils')(column, values, alias, agg, cmp, prefix, suffix, then_value, else_value, quote_identifiers, distinct)) }}
-- {% endmacro %}

with last_30_days_events as (

    select * 
    from {{ ref('stg_event') }} 
    where dateadd(day, 30, event_datetime),
  
pivot_events as (
  select
   user_id,
   {{ pivot_event_name('event_name', dbt_utils.get_column_values(ref('last_30_days_events'), 'event_name')) }}
from {{ ref('last_30_days_events') }} 
group by user_id

)

select * from pivot_events
