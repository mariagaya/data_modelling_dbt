with cumulative_users_count as (
                select
                    ur.activity_month,
                    ur.company_id,
                    max(ur.user_registered) AS members_count
                from (
                    select
                        reg_unreg.activity_month,
                        reg_unreg.company_id,
                        sum(reg_unreg.user_count) over (order by reg_unreg.year_month) as user_registered
                    from
                        (
                            (
                                select
                                    cast(dateadd(month, datediff(month, 0, 'user_signuped_time'), 0) as date) as activity_month
                                    company_id,
                                    count(distinct user_id) as user_count
                                from {{ ref('stg_user') }}
                                group by cast(dateadd(month, datediff(month, 0, 'user_signuped_time'), 0) as date), company_id
                            )

                            union all

                            (
                                select
                                    cast(dateadd(month, datediff(month, 0, 'user_leaved_time'), 0) as date) as activity_month
                                    company_id,
                                    count(distinct user_id) * -1 as user_count
                                from {{ ref('stg_user') }}
                                where user_leaved_time IS NOT NULL
                                group by cast(dateadd(month, datediff(month, 0, 'user_leaved_time'), 0) as date), company_id

                            )
                        ) AS reg_unreg
                 ) AS ur
            group by ur.activity_month, ur.company_id
            order by ur.company_id, ur.activity_month;
),

company_tier as (
      select 
           activity_month,
           company_id,
           case 
              when members_count < 10 then 'C'
              when members_count < 50 then 'B'
              else 'A'
           end as company_tier,
           members_count
       from {{ ref('cumulative_users_count') }} 
       group by year_month, company_id
)

select * from company_tier
