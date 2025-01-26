--Example 1
SELECT 
	tpep_pickup_datetime AS pickup_datetime,
	tpep_dropoff_datetime AS dropoff_datetime,
	"PULocationID",
	pickups."Zone" AS pickup_zone,
	"DOLocationID",
	dropoffs."Zone" AS dropoff_zone
	
FROM 
	public.yellow_taxi_data AS t
INNER JOIN 
	public.zones AS pickups  ON t."PULocationID" = pickups."LocationID"  
INNER JOIN
	public.zones AS dropoffs  ON t."DOLocationID" = dropoffs."LocationID"  
LIMIT 10;


--Example 2
SELECT 
    t.transaction_id,
    t.amount,
    t.transaction_date,
    sender.user_name AS sender_name,
    receiver.user_name AS receiver_name
FROM 
    transactions t
INNER JOIN 
    users sender ON t.sender_id = sender.user_id
INNER JOIN 
    users receiver ON t.receiver_id = receiver.user_id;