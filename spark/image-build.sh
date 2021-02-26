#!/bin/bash

SPARK_VERSION="3.0.1"
HADOOP_VERSION="2.7"
JUPYTERLAB_VERSION="2.1.5"

set -e

docker build \
    -f ./docker/base/spark-base.Dockerfile \
    -t hanyoon1108/spark-base:"${SPARK_VERSION}" ./docker/base

docker build \
    -f ./docker/master/spark-master.Dockerfile \
    -t hanyoon1108/spark-master:"${SPARK_VERSION}" ./docker/master

docker build \
    -f ./docker/worker/spark-worker.Dockerfile \
    -t hanyoon1108/spark-worker:"${SPARK_VERSION}" ./docker/worker

docker build \
    -f ./docker/submit/spark-submit.Dockerfile \
    -t hanyoon1108/spark-submit:"${SPARK_VERSION}" ./docker/submit

docker build \
    -f ./docker/jupyterlab/jupyterlab.Dockerfile \
    -t hanyoon1108/jupyterlab:"${SPARK_VERSION}" ./docker/jupyterlab