{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ adapter_macro('dbt_utils.dateadd', datepart, interval, from_date_or_timestamp) }}
{% endmacro %}

with last_30_days_events as (
        select * 
        from {{ ref('stg_event') }} 
        where dateadd(day, 30, event_datetime),
  
pivot_event_name as (
        select
            user_id,
            {{ dbt_utils.pivot('event_name',dbt_utils.get_column_values(ref('last_30_days_events'), 'event_name'),
                agg='count',
                suffix='_count') }}
        from {{ ref('last_30_days_events') }} 
        group by user_id
)
  
pivot_event_date as (
        select
            user_id,
            {{ dbt_utils.pivot('event_name',dbt_utils.get_column_values(ref('last_30_days_events'), 'event_datetime'),
                agg='max',
                suffix='_last_date') }}
        from {{ ref('last_30_days_events') }} 
        group by user_id
)

select *
  from pivot_event_name en
  left join pivot_event_date ed on en.user_id = ed.user_id
