with 

source as (

    select * from {{ ref('stg_fhv_tripdata') }}

),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
),
fhv_trips as (

    select
        dispatching_base_num,
        pickup_datetime,
        dropoff_datetime,
        pickup_locationid,
        dropoff_locationid,
        sr_flag,
        affiliated_base_number
        
    from source
--Week 4 homework requirements
)

select 

    fhv_trips.dispatching_base_num,
    EXTRACT(YEAR FROM dropoff_datetime ) AS year,
    EXTRACT(MONTH FROM dropoff_datetime) AS month,
    fhv_trips.pickup_datetime,
    fhv_trips.dropoff_datetime,
    fhv_trips.pickup_locationid,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone,     
    fhv_trips.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,      
    fhv_trips.sr_flag,
    fhv_trips.affiliated_base_number

from fhv_trips
inner join dim_zones as pickup_zone
on fhv_trips.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_trips.dropoff_locationid = dropoff_zone.locationid

