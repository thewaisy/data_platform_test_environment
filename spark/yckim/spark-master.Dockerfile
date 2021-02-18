# 3. Spark master image
FROM spark-base 

ARG spark_master_web_ui=8080

# exposing port configured at environment variable 
# to allow workers to connect to the master node
EXPOSE ${spark_master_web_ui} ${SPARK_MASTER_PORT}
# container startup command for starting the node as a master instance
# args - master class   
CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out