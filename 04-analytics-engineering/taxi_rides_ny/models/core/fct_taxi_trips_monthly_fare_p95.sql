{{
    config(
        materialized='table'
    )
}}

--Question 6: Compute the continous percentile of fare_amount partitioning by service_type, year and and month
--PERCENTILE_CONT -->	Computes the specified percentile for a value, using linear interpolation.
/*
    -Interpolation in mathematics is a method of estimating unknown values that fall within the range of known values. 
    -This technique is used to construct new data points within the range of a discrete set of known data points. 
    -The goal of interpolation is to approximate the value of a function for a given point using the values of the function at nearby points.

*/


WITH fact_trips_data AS (

    SELECT 
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        service_type,
        fare_amount

    FROM {{ ref('fact_trips') }}
    WHERE 
        1=1
        AND fare_amount > 0
        AND trip_distance > 0
        AND payment_type_description IN ('Cash', 'Credit Card')

),

percentile_calculations AS (
    SELECT
        service_type,
        year,
        month,
        fare_amount,
        ROUND(PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY service_type, year, month),2) AS median_fare,
        ROUND(PERCENTILE_CONT(fare_amount, 0.25) OVER(PARTITION BY service_type, year, month),2) AS first_quartile,
        ROUND(PERCENTILE_CONT(fare_amount, 0.75) OVER(PARTITION BY service_type, year, month),2) AS third_quartile,    
        ROUND(PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY service_type, year, month),2) AS p97, --mandatory
        ROUND(PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION BY service_type, year, month),2) AS p95,  --mandatory
        ROUND(PERCENTILE_CONT(fare_amount, 0.90) OVER(PARTITION BY service_type, year, month),2) AS p90 --mandatory
    FROM fact_trips_data
)

    SELECT 
        service_type,
        year,
        month,
        fare_amount,
        median_fare,
        first_quartile,
        third_quartile
        p97,
        p95,
        p90
    FROM 
        percentile_calculations
    WHERE 
        month = 4
        AND year = 2020

--I could not get the right answers for some reason. Seems related to the amount of the data ingested in the staging source tables.

--SELECT count(*) from {{ ref('stg_yellow_tripdata') }}