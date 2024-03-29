{{ config(materialized='table') }}
with source as (
    select * from {{ source('staging', 'bestsellers') }}
)
    select
        list_name_encoded,
        title,
        author,
        avg(price) AS avg_price,
        avg(rank) AS avg_rank,
        max(weeks_on_list) AS longest_streak
    
    from source
    group by 1,2,3
    order by longest_streak desc, avg_rank
    limit 100