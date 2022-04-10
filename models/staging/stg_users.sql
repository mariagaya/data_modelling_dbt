with source as (

    select * from {{ ref('gitbook-analytics.itw_test.users') }}

),

last_status as (

    select user_id 
        , company_id
        , username
        , displayName
        , user_signuped_time
        , user_leaved_time
        , email
        , country
        , MAX(_extracted_at)
    from alerts.alerts_log
    group by user_id;

)

select * from last_status
