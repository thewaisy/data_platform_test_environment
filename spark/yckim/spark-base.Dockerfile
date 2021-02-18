# 2. Spark base image
FROM cluster-base 


# download, unpack, move apache spark latest version with official repository
ARG spark_version=3.0.1
ARG hadoop_version=2.7 

COPY requirements.txt requirements.txt
RUN apt-get update -y && \
    apt-get install -y curl wget && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz

# configure spark variable 
ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

RUN wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar -O ${SPARK_HOME}/jars/mysql-connector-java-5.1.47.jar

WORKDIR ${SPARK_HOME}