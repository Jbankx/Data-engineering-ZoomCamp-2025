export JAVA_HOME="/C/Program Files/jdk-11.0.25"
export PATH="${JAVA_HOME}/bin:${PATH}"

export HADOOP_HOME="/C/Program Files/Spark/hadoop-3.2.0"
export PATH="${HADOOP_HOME}/bin:${PATH}"

export SPARK_HOME="/C/Program Files/spark-3.3.2-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"

export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"

SPARK_WIN=`cygpath -w ${SPARK_HOME}`

export PYTHONPATH="${SPARK_WIN}\\python\\"
export PYTHONPATH="${SPARK_WIN}\\python\\lib\\py4j-0.10.9.5-src.zip;$PYTHONPATH"

