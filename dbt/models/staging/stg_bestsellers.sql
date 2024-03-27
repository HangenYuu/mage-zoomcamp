with 

source as (

    select * from {{ source('staging', 'bestsellers') }}

),

renamed as (

    select
        published_date,
        list_name,
        list_name_encoded,
        rank,
        isbn13,
        isbn10,
        title,
        author,
        description,
        amazon_product_url,
        price,
        weeks_on_list

    from source

)

select * from renamed
