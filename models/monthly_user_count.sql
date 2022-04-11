

with cumulative_users_count as (
                select
                    ur.year_month,
                    ur.company_id,
                    max(ur.user_registered) AS members_count
                from (
                    select
                        reg_unreg.year_month,
                        reg_unreg.company_id,
                        SUM(reg_unreg.user_count) over (order by reg_unreg.year_month) as user_registered
                    from
                        (
                            (
                                select
                                    date_format(convert_tz(from_unixtime(created_at), '+00:00', '+02:00'), '%x-M%m') as year_month,
                                    company_id,
                                    count(distinct user_id) as user_count
                                from {{ ref('stg_user') }}
                                group by date_format(convert_tz(from_unixtime(created_at), '+00:00', '+02:00'), '%x-M%m'), ladenid
                            )

                            union all

                            (
                                select
                                    date_format(convert_tz(from_unixtime(user_leaved_time), '+00:00', '+02:00'), '%x-M%m') as year_month,
                                    company_id,
                                    count(distinct user_id) as user_count
                                from {{ ref('stg_user') }}
                                where user_leaved_time IS NOT NULL
                                group by date_format(convert_tz(from_unixtime(user_leaved_time), '+00:00', '+02:00'), '%x-M%m'), ladenid

                            )
                        ) AS reg_unreg
                 ) AS ur
            group by ur.year_month, ur.company_id
            order by ur.company_id, ur.year_month;
),

company_tier as (
      select 
           year_month,
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
