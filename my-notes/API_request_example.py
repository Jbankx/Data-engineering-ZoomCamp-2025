import requests
from datetime import datetime, timedelta

#Setting parameters 
today_date = datetime.now()
date_15_days_ago = today_date - timedelta(days=15)
start_time= date_15_days_ago.strftime('%Y-%m-%d')
end_time = today_date.strftime('%Y-%m-%d')

# Define the API endpoint
url = f"https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime={start_time}&endtime={end_time}"

# Send a GET request
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:

   data = response.json()

   # Extract earthquake features
   features = data['features']

...