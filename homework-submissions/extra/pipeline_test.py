# Let's create an example pipeline. 
# We will create a dummy pipeline.py Python script that receives an argument and prints it.
# More info on: https://github.com/ManuelGuerra1987/data-engineering-zoomcamp-notes/tree/main/1_Containerization-and-Infrastructure-as-Code

import sys
import pandas 

day = sys.argv[1]

print(f'job finished successfully for day {day}')

#Execute this in terminal using "'python pipeline_test.py 5' "