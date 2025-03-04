{{ config(
    materialized='table' 
) }}


--Question 5:
/*
    - Compute the Quarterly Revenues for each year for based on total_amount
    - Compute the Quarterly YoY (Year-over-Year) revenue growth
        e.g.: In 2020/Q1, Green Taxi had -12.34% revenue growth compared to 2019/Q1
*/

WITH quarterly_data AS (
    SELECT
        service_type, 
        DATE_TRUNC(CAST(pickup_datetime AS DATE), QUARTER) AS quarter_start,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter_number,
        EXTRACT(YEAR FROM pickup_datetime) AS year,       
        SUM(total_amount) AS current_year_revenue
    FROM
        {{ ref('fact_trips') }}
    WHERE 
        --Removing outliers for clean data
        (EXTRACT(YEAR FROM pickup_datetime) >= 2019 AND EXTRACT(YEAR FROM pickup_datetime) <= 2021)
    GROUP BY
        service_type,
        DATE_TRUNC(CAST(pickup_datetime AS DATE), QUARTER), --quarter_start
        EXTRACT(QUARTER FROM pickup_datetime), --quarter_number
        EXTRACT(YEAR FROM pickup_datetime) --year
        
),
--CTE yoy_growth:
--Uses window functions to calculate the previous year's revenue (LAG(total_revenue, 1) OVER (PARTITION BY quarter_number, service_type ORDER BY year))

yoy_growth AS (
    SELECT
        service_type,
        quarter_start,
        CASE 
            WHEN quarter_number = 1 THEN 'Q1'
            WHEN quarter_number = 2 THEN 'Q2'
            WHEN quarter_number = 3 THEN 'Q3'
            WHEN quarter_number = 4 THEN 'Q4'
        END 
        AS quarter_number,        
        year,
        current_year_revenue, 
        LAG(current_year_revenue, 1) OVER(PARTITION BY quarter_number, service_type ORDER BY year) AS previous_year_revenue

    FROM
        quarterly_data

)
    SELECT 
        service_type,
        quarter_start,
        quarter_number,
        year,
        year||'-'||quarter_number AS year_quarter,
        current_year_revenue,
        previous_year_revenue,
        current_year_revenue - previous_year_revenue AS YOY_growth_amount,
        --Computes the YoY growth % using the formula: if previous_year_revenue : 100 THEN (current_year_revenue - previous_year_revenue) : x
        ROUND((((current_year_revenue - previous_year_revenue) / previous_year_revenue) * 100),2) AS YOY_growth_percentage



    FROM yoy_growth
    ORDER BY
        service_type,
        quarter_start

--Considering the YoY Growth in 2020, which were the yearly quarters with the best (or less worse) and worst results for green, and yellow
--Answer. green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}