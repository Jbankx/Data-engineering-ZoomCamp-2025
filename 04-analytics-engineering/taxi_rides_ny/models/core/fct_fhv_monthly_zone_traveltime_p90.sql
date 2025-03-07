with 

source as (

    select * from {{ ref('dim_fhv_trips') }}

),


--1 - For each record in dim_fhv_trips.sql, compute the timestamp_diff in seconds between dropoff_datetime and pickup_datetime - we'll call it trip_duration for this exercise
--2 - Compute the continous p90 of trip_duration partitioning by year, month, pickup_location_id, and dropoff_location_id

trip_duration_data AS (
    select 
        dispatching_base_num,
        year,
        month,
        pickup_datetime,
        dropoff_datetime,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration, --new requirement
        pickup_locationid,
        pickup_borough, 
        pickup_zone,     
        dropoff_locationid,
        dropoff_borough, 
        dropoff_zone,      
        sr_flag,
        affiliated_base_number
    FROM source
)

select 
*,
ROUND(PERCENTILE_CONT(trip_duration, 0.90) OVER(PARTITION BY  year, month, pickup_locationid, dropoff_locationid),2) AS p90_trip_duration ---new requirement
FROM trip_duration_data

