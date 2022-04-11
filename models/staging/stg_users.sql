with source as (

    select * from {{ ref('gitbook-analytics.itw_test.users') }}

),

first_entry as (

    select user_id,
            company_id,
            user_signuped_time,
            MIN(_extracted_at) as first_entry_date
    from source
    group by user_id;

),

last_entry as (

    select user_id,
            company_id,
            user_leaved_time,
            MAX(_extracted_at) as last_entry_date
    from source
    group by user_id;

)

select fe.user_id,
        fe.company_id,
        fe.user_signuped_time,
        le.user_leaved_time
from first_entry fe
left join last_entry le on fe.user_id = le.user_id
