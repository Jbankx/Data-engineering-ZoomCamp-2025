SELECT  *
FROM `local-proxy-450707-i1.zoomcamp.yellow_tripdata` LIMIT 10;


------------------------------------------------------------------------------------------

-- Creating external table referring to gcs path
--Example test (yellow external table collate)
CREATE OR REPLACE EXTERNAL TABLE `local-proxy-450707-i1.zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://kestra-zoomcamp-jalhassan-bucket/yellow_tripdata_2019-*.csv']
);


--Example test (green external table collate)
CREATE OR REPLACE EXTERNAL TABLE `local-proxy-450707-i1.zoomcamp.external_green_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://kestra-zoomcamp-jalhassan-bucket/green_tripdata_2019-*.csv']
);

--verification (external table)
SELECT COUNT(1) FROM `local-proxy-450707-i1.zoomcamp.external_green_tripdata`;
--6044050

--verification (main table)
SELECT COUNT(1) FROM local-proxy-450707-i1.zoomcamp.green_tripdata ;
--6044050


------------------------------------------------------------------------------------------

--FROM THE DE-ZOOMCAMP 3.1.1 HOMEWORK 
--https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/03-data-warehouse/homework.md


-- Creating external table referring to gcs path
-- Create an external table using the yellow Taxi Trip Records Data for 2024 you uploaded.
CREATE OR REPLACE EXTERNAL TABLE `local-proxy-450707-i1.zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://kestra-zoomcamp-jalhassan-bucket/yellow_tripdata_2024-*.parquet']
);

-- Check yellow trip data
SELECT * FROM local-proxy-450707-i1.zoomcamp.external_yellow_tripdata 
ORDER BY tpep_pickup_datetime DESC
limit 10;



-- Create an external table using the Yellow Taxi Trip Records.
-- Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table).

CREATE OR REPLACE TABLE local-proxy-450707-i1.zoomcamp.yellow_tripdata_non_partitoned AS
SELECT * FROM local-proxy-450707-i1.zoomcamp.external_yellow_tripdata;



------------------------------------------------------------------------------------------
-- Question 1: What is count of records for the 2024 Yellow Taxi Data?
SELECT COUNT(*) FROM local-proxy-450707-i1.zoomcamp.external_yellow_tripdata;
--20332093



------------------------------------------------------------------------------------------
-- Question 2: 
-- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
--External table
SELECT COUNT(DISTINCT(PULocationID)) FROM `local-proxy-450707-i1.zoomcamp.external_yellow_tripdata`; --0 MB


--Materialized table
SELECT COUNT(DISTINCT(PULocationID)) FROM `local-proxy-450707-i1.zoomcamp.yellow_tripdata_non_partitoned`; --155.12 MB


------------------------------------------------------------------------------------------
--Question 3
--Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. 
SELECT PULocationID FROM `local-proxy-450707-i1.zoomcamp.yellow_tripdata_non_partitoned`;

--Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different? --310.24 MB
--Answer: BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
SELECT 
  PULocationID,
  DOLocationID
FROM `local-proxy-450707-i1.zoomcamp.yellow_tripdata_non_partitoned`;


------------------------------------------------------------------------------------------
--Question 4 How many records have a fare_amount of 0?
SELECT COUNT(1) FROM `local-proxy-450707-i1.zoomcamp.external_yellow_tripdata`
WHERE fare_amount = 0;


------------------------------------------------------------------------------------------

-- Create a partitioned table from external table
--Test
CREATE OR REPLACE TABLE local-proxy-450707-i1.zoomcamp.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_dropoff_datetime) AS
SELECT * FROM local-proxy-450707-i1.zoomcamp.external_yellow_tripdata;


-- Let's look into the partitons
--Test
SELECT table_name, partition_id, total_rows
FROM `zoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY partition_id;


-- Question 5:
-- What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)
-- Creating a partition and cluster table
CREATE OR REPLACE TABLE local-proxy-450707-i1.zoomcamp.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS --Clustering can be more effective on larger tables (not always beneficial)
SELECT * FROM local-proxy-450707-i1.zoomcamp.external_yellow_tripdata;


------------------------------------------------------------------------------------------

--Question 6:
--Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
--Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?
--Choose the answer which most closely matches.


--Materialized table scans --310.24 MB
SELECT 
  DISTINCT(VendorID) as unique_VendorsID
FROM local-proxy-450707-i1.zoomcamp.yellow_tripdata_non_partitoned
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';


--Partitioned and clustered table scans --26.84 MB 
SELECT 
  DISTINCT(VendorID) as unique_VendorsID
FROM local-proxy-450707-i1.zoomcamp.yellow_tripdata_partitoned_clustered
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';


------------------------------------------------------------------------------------------

--Question 7. Where is the data for external tables stored? 
--GCP Bucket



------------------------------------------------------------------------------------------
--Question 8 :
--It is best practice in Big Query to always cluster your data: False
--Clustering can be more effective on larger tables 

