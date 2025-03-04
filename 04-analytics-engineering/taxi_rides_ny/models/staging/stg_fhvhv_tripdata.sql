with 

source as (

    select * from {{ source('staging', 'external_fhvhv_tripdata') }}

),

renamed as (

    select
        {{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("integer")) }} as dispatching_base_num,
        
    -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropOff_datetime as timestamp) as dropoff_datetime,

    -- identifiers    
        {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
        {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
        {{ dbt.safe_cast("sr_flag", api.Column.translate_type("integer")) }} as sr_flag,
        {{ dbt.safe_cast("affiliated_base_number", api.Column.translate_type("integer")) }} as affiliated_base_number,
        

    from source

)

select * from renamed
