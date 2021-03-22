# This shell script is used for building three docker images
# 1. spark-2.1.1-without-hadoop
# 2. spark-2.1.1-without-hadoop-python

WORK_DIR=$(cd "`dirname "$0"`"; pwd)

# First download built spark distribution package from apache
# referrence: https://spark.apache.org/downloads.html
wget https://downloads.apache.org/spark/spark-3.1.1/spark-3.1.1-bin-without-hadoop.tgz -O $WORK_DIR/spark-3.1.1-bin-without-hadoop.tgz

# extract
tar -xf $WORK_DIR/spark-3.1.1-bin-without-hadoop.tgz -C $WORK_DIR

BUILD_HOME=$WORK_DIR/spark-3.1.1-bin-without-hadoop

cd $BUILD_HOME

function build_and_push_spark() {
    # build spark
    /bin/bash ./bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-3.1.1-without-hadoop -t alpha build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-3.1.1-without-hadoop/spark:alpha $DOCKER_REGISTRY/spark-3.1.1-without-hadoop:alpha 
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-3.1.1-without-hadoop:alpha 
}

# build spark-with-r
function build_and_push_spark_r() {
    # build spark
    /bin/bash ./bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-3.1.1-without-hadoop -t alpha -R $BUILD_HOME/kubernetes/dockerfiles/spark/bindings/R/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-3.1.1-without-hadoop/spark-r:alpha $DOCKER_REGISTRY/spark-3.1.1-without-hadoop-with-r:alpha 
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-3.1.1-without-hadoop-with-r:alpha 
}

# build spark-with python
function build_and_push_spark_py() {
    # build spark
    /bin/bash ./bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-3.1.1-without-hadoop -t alpha -p $BUILD_HOME/kubernetes/dockerfiles/spark/bindings/python/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-3.1.1-without-hadoop/spark-py:alpha $DOCKER_REGISTRY/spark-3.1.1-without-hadoop-with-py:alpha 
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-3.1.1-without-hadoop-with-py:alpha
}

build_and_push_spark
build_and_push_spark_r
build_and_push_spark_py