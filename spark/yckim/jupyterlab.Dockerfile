FROM cluster-base

# -- Layer: JupyterLab

ARG spark_version=3.0.1
ARG jupyterlab_version=2.1.5
ARG jupyter=8888

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install wget pyspark==${spark_version} jupyterlab==${jupyterlab_version} numpy
# -- Runtime

EXPOSE ${jupyter}
WORKDIR ${SHARED_WORKSPACE}/jupyter
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
