#!/bin/bash

SPARK_VERSION="3.0.1"
HADOOP_VERSION="2.7"
JUPYTERLAB_VERSION="2.1.5"

set -e

docker build \
    -f ./docker/base/spark-base:"${SPARK_VERSION}".Dockerfile \
    -t hanyoon/spark-base:"${SPARK_VERSION}" .

docker build \
    -f ./docker/master/spark-master.Dockerfile \
    -t hanyoon/spark-master:"${SPARK_VERSION}" .

docker build \
    -f ./docker/worker/spark-worker.Dockerfile \
    -t hanyoon/spark-worker:"${SPARK_VERSION}" .

docker build \
    -f ./docker/submit/spark-submit.Dockerfile \
    -t hanyoon/spark-submit:"${SPARK_VERSION}" .

docker build \
    -f ./docker/jupyterlab/jupyterlab.Dockerfile \
    -t hanyoon/jupyterlab:"${SPARK_VERSION}" .