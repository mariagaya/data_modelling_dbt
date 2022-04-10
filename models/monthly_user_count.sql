with user_reg_and_unreg as (

    (select month(user_signuped_time) as activity_month
          company_id,
          count(distinct user_id) as registered_users
    from {{ ref('stg_users') }}
    where user_leaved_time is not null
    group by month(user_signuped_time), company_id)
  
    union
  
    (select month(user_signuped_time) as activity_month
          company_id,
          count(distinct user_id) as unregistered_users
    from {{ ref('stg_users') }}
    where user_leaved_time is null
    group by month(user_signuped_time), company_id)
),
  
members_count as (
      select activity_month,
              company_id,
              registered_users - unregistered_users as members_count
      from {{ ref('user_reg_and_unreg') }} 
      group by activity_month, company_id
      
),

company_tier as (
      select activity_month,
       company_id,
       case 
          when members_count < 10 then 'C'
          when members_count < 50 then 'B'
          else 'A'
       end as company_tier
    from {{ ref('members_count') }} 
    group by activity_month, company_id
)

select * from company_tier
