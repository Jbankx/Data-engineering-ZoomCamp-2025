--QUESTION 3
--In between 1 (exclusive) and 3 miles (inclusive),
WITH Cte_all as(
SELECT
    CAST(lpep_pickup_datetime AS DATE) AS Day_pickup,
    COUNT(*) AS daily_trip_count,
	SUM (CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS "1 mile max",
	SUM (CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS "1 to 3 miles",
	SUM (CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS "3 to 7 miles",
	SUM (CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS "7 to 10 miles",
	SUM (CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS "10 miles over",
	SUM(COUNT(*)) OVER() AS total_trips
FROM
    public.green_taxi_data
WHERE
	--trip_distance != 0
    lpep_pickup_datetime >= '2019-10-01 00:00:00'
    AND lpep_pickup_datetime < '2019-11-01 00:00:00'
GROUP BY
    CAST(lpep_pickup_datetime AS DATE)
ORDER BY
    Day_pickup ASC
)

SELECT 
 sum("1 mile max") as total_1_mile_max,
 sum("1 to 3 miles") as total_1_to_3_miles,
 sum("3 to 7 miles") as total_3_to_7_miles,
 sum("7 to 10 miles") as total_7_to_10_miles,
 sum("10 miles over") as total_10_miles_max
FROM Cte_all;


-----------------------------------------------------------------------------

--QUESTION 4
--Which was the pick up day with the longest trip distance? 
--Use the pick up time for your calculations.
--Tip: For every day, we only care about one single trip with the longest distance.
	
SELECT
	CAST(lpep_pickup_datetime AS DATE) AS Day_pickup,
	MAX(trip_distance) AS longest_trip_per_day
FROM public.green_taxi_data
GROUP BY Day_pickup
ORDER BY longest_trip_per_day DESC
LIMIT 1;



--------------------------------------------------------------------------------
--QUESTION 5
--Which were the top pickup locations
--with over 13,000 in total_amount (across all trips) for 2019-10-18?
--Consider only lpep_pickup_datetime when filtering by date.

--Exploring the zones table
SELECT 
*
FROM public.zones
LIMIT 5

--ANSWER
SELECT 
	z."Zone" AS pickup_location,
	SUM(CAST(t.total_amount AS DECIMAL)) AS total_amount
FROM 
	public.green_taxi_data as t
INNER JOIN public.zones as z
	ON t."PULocationID" = z."LocationID"
GROUP BY 
	pickup_location
HAVING	
	SUM(CAST(t.total_amount AS DECIMAL)) > 13000	
ORDER BY total_amount DESC

-----------------------------------------------------------------------------
--QUESTION 6
WITH 
	cte_pickups as (
		SELECT 
			CAST(lpep_pickup_datetime AS DATE) AS pickup_date,
			z."Zone" AS pickup_location,
			t."PULocationID" AS pickup_id,
			t."DOLocationID" AS dropoff_id,
			CAST(t.tip_amount AS DECIMAL) AS tip_amount
		FROM 
			public.green_taxi_data as t
		INNER JOIN public.zones as z
			ON t."PULocationID" = z."LocationID"
		WHERE 
			EXTRACT(YEAR FROM t.lpep_pickup_datetime) = '2019'
			AND EXTRACT(MONTH FROM t.lpep_pickup_datetime) = '10'
			AND z."Zone"='East Harlem North'
),

	cte_tips_partition AS (
		SELECT 
			cte.pickup_date,
			cte.pickup_location,
			z."Zone" AS dropoff_location,
			--cte.pickup_id, --optional
			--cte.dropoff_id, --optional,
			cte.tip_amount,
			SUM(tip_amount) OVER(PARTITION BY z."Zone") AS total_drop_off_zone_tip 
	FROM 
		cte_pickups as cte
	INNER JOIN public.zones as z
			ON cte.dropoff_id = z."LocationID"	

)
SELECT 
	dropoff_location,
	MAX(total_drop_off_zone_tip) AS maximum_drop_off_tip
FROM cte_tips_partition
	GROUP BY 
		dropoff_location
ORDER BY maximum_drop_off_tip DESC;


-----------------------------------------------------------------------------
--QUESTION 6
"""For the passengers picked up in October 2019 
in the zone named "East Harlem North" 
which was the drop off zone that had the largest tip?

Note: it's tip , not trip
We need the name of the zone, not the ID.
"""

WITH 
	cte_pickups as (
		SELECT 
			CAST(lpep_pickup_datetime AS DATE) AS pickup_date,
			z."Zone" AS pickup_location,
			t."PULocationID" AS pickup_id,
			t."DOLocationID" AS dropoff_id,
			CAST(t.tip_amount AS DECIMAL) AS tip_amount
		FROM 
			public.green_taxi_data as t
		INNER JOIN public.zones as z
			ON t."PULocationID" = z."LocationID"
		WHERE 
			EXTRACT(YEAR FROM t.lpep_pickup_datetime) = '2019'
			AND EXTRACT(MONTH FROM t.lpep_pickup_datetime) = '10'
			AND z."Zone"='East Harlem North'
),

	cte_tips_partition AS (
		SELECT 
			cte.pickup_date,
			cte.pickup_location,
			z."Zone" AS dropoff_location,
			--cte.pickup_id, --optional
			--cte.dropoff_id, --optional,
			cte.tip_amount,
			SUM(tip_amount) OVER(PARTITION BY z."Zone") AS total_drop_off_zone_tip 
	FROM 
		cte_pickups as cte
	INNER JOIN public.zones as z
			ON cte.dropoff_id = z."LocationID"	

)
SELECT 
	dropoff_location,
	MAX(total_drop_off_zone_tip) AS maximum_drop_off_tip
FROM cte_tips_partition
	GROUP BY 
		dropoff_location
ORDER BY maximum_drop_off_tip DESC
;
