-- Example 1
--dbt:_utils.date_spine --> To create a secquence of dates

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2025-03-01' as date)",
    end_date="cast('2025-03-17' as date)"
   )
}}



--Example 2 (1 week dates)
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="current_date()",
    end_date="date_add(current_date(), INTERVAL 1 WEEK)"
   )
}}






----------------------------------------------------------------------------





--Example 3: dbt_utils.deduplicate macro
--This macro returns the sql required to remove duplicate rows from a model, source, or CTE.
with my_cte as (
    select *
    from {{ source('staging', 'green_tripdata') }}
    where vendorid is not null 
),
deduplicated_cte as (
  {{ dbt_utils.deduplicate(
      relation='my_cte',
      partition_by='vendorid, cast(lpep_pickup_datetime as date), cast(lpep_dropoff_datetime as date), COALESCE(CAST(PULocationID AS STRING), ""), COALESCE(CAST(DOLocationID AS STRING), "")', 
      order_by='lpep_dropoff_datetime desc',
     )
  }}
)
select * from deduplicated_cte;


--------------------------
--Option 2: Referencing the model (easier to understand)
--In this example we get the id of pick up and drop off uniquely combined, and filter just the latest drop off date)

{{ dbt_utils.deduplicate(
    relation=ref('stg_fhv_tripdata'),
    partition_by='pickup_locationid, dropoff_locationid',
    order_by='dropOff_datetime desc',
   )
}}