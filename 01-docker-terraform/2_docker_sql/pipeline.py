import sys

import pandas as pd

print(sys.argv)

day = sys.argv[1]

# some fancy stuff with pandas

print(f'job finished successfully for day = {day}')

# Note: you can also dockerise a data pipeline (Watch DE Zoomcamp 1.2.4) 
# https://www.youtube.com/watch?v=B1WwATwf-vY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=8

# Project focuses on using "Airflow" instead of the above (out of project scope)