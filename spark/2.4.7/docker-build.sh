# This shell script is used for building three docker images
# 1. spark-2.4.7-without-hadoop
# 2. spark-2.4.7-without-hadoop-python



# First download built spark distribution package from apache
# referrence: https://spark.apache.org/downloads.html
wget https://downloads.apache.org/spark/spark-2.4.7/spark-2.4.7-bin-without-hadoop.tgz

# extract
tar -xf spark-2.4.7-bin-without-hadoop.tgz
BUILD_HOME=$(cd "`dirname "$0"`"/..; pwd)spark-2.4.7-bin-without-hadoop


function build_and_push_spark() {
    # build spark
    /bin/bash $BUILD_HOME/bin/docker-image-tool.sh -r $DOCKER_REPO/spark-2.4.7-without-hadoop -t alpha build
    # fixed tag name pattern
    docker tag $DOCKER_REPO/spark-2.4.7-without-hadoop/spark:alpha $DOCKER_REPO/spark-2.4.7-without-hadoop:alpha 
    # already logged in Makefile
    docker push $DOCKER_REPO/spark-2.4.7-without-hadoop:alpha 
}

# build spark-with-r
function build_and_push_spark_r() {
    # build spark
    /bin/bash $BUILD_HOME/bin/docker-image-tool.sh -r $DOCKER_REPO/spark-2.4.7-without-hadoop-with-r -t alpha -R $BUILD_HOME/kubernetes/dockerfiles/spark/bindings/R/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REPO/spark-2.4.7-without-hadoop/spark-r:alpha $DOCKER_REPO/spark-2.4.7-without-hadoop-with-r:alpha 
    # already logged in Makefile
    docker push $DOCKER_REPO/spark-2.4.7-without-hadoop-with-r:alpha 
}

# build spark-with python
function build_and_push_spark_py() {
    # build spark
    /bin/bash $BUILD_HOME/bin/docker-image-tool.sh -r $DOCKER_REPO/spark-2.4.7-without-hadoop-with-py -t alpha -p $BUILD_HOME/kubernetes/dockerfiles/spark/bindings/python/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REPO/spark-2.4.7-without-hadoop/spark:alpha $DOCKER_REPO/spark-2.4.7-without-hadoop-with-py:alpha 
    # already logged in Makefile
    docker push $DOCKER_REPO/spark-2.4.7-without-hadoop-with-py:alpha
}

build_and_push_spark
build_and_push_spark_r
build_and_push_spark_py