# export JAVA_HOME="/c/Users/lourh/OneDrive/Documentos/Junior/Data Engineerig Zoomcamp 2025/data-engineering-zoomcamp/05-batch/spark/jdk-11.0.13"
# We use java 8 installed (due to error: Py4JJavaError: An error occurred while calling o34.parquet.)
export JAVA_HOME="/C/Program Files/Java/jre1.8.0_441"
export PATH="${JAVA_HOME}/bin:${PATH}"

#export HADOOP_HOME="/c/Users/lourh/OneDrive/Documentos/Junior/Data Engineerig Zoomcamp 2025/data-engineering-zoomcamp/05-batch/spark/hadoop-3.2.0"
# We use this hadoop 3.0.0 installed (due to error: Py4JJavaError: An error occurred while calling o34.parquet.)- We just need the winutils.exe really
export HADOOP_HOME="/C/Program Files/hadoop"
export PATH="${HADOOP_HOME}/bin:${PATH}"

export SPARK_HOME="/C/Program Files/spark-3.3.2-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"

export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"
