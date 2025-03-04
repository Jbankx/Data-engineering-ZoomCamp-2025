{{ config(
    materialized='table' 
) }}

WITH quarterly_data AS (
    SELECT
     -- Reveneue grouping 
        DATE_TRUNC(pickup_datetime, QUARTER) AS quarter,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter_number,
        service_type, 
     -- Reveneue total per quarter        
        SUM(total_amount) AS total_revenue
    FROM
        {{ ref('fact_trips') }}
    GROUP BY
        service_type,
        DATE_TRUNC(pickup_datetime, QUARTER),
        EXTRACT(YEAR FROM pickup_datetime),
        EXTRACT(QUARTER FROM pickup_datetime)
)

    SELECT
        service_type,
        year,
        CASE 
            WHEN quarter_number = 1 THEN 'Q1'
            WHEN quarter_number = 2 THEN 'Q2'
            WHEN quarter_number = 3 THEN 'Q3'
            WHEN quarter_number = 4 THEN 'Q4'
        END 
        AS quarter_number,
        total_revenue
    FROM
        quarterly_data
    ORDER BY
        service_type,
        year,
        quarter_number