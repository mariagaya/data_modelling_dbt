with source as (

    select * from {{ ref('gitbook-analytics.itw_test.company') }}

),

last_status as (

    select
        company_id,
        company_name,
        created_at, 
        country,
        MAX(_extracted_at) as last_status_date
    from source
    group by company_id

)

select 
    company_id,
    company_name,
    created_at, 
    country,
from last_status
