# 4. Spark worker image
FROM spark-base

ARG spark_worker_web_ui=8081
# exposing port to the worker web ui
EXPOSE ${spark_worker_web_ui}
# container startup command to run built-in deploy script
# args - worker class, master network address
CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out