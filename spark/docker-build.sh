WORK_DIR=$(cd "`dirname "$0"`"; pwd)

function download_and_extract_spark_dist() {
    # First download built spark distribution package from apache
    # referrence: https://spark.apache.org/downloads.html
    wget https://downloads.apache.org/spark/spark-$1/spark-$1-bin-hadoop$2.tgz -O $3/spark-$1-bin-hadoop$2.tgz
    tar -xf $3/spark-$1-bin-hadoop$2.tgz -C $3
}

function build_and_push_spark() {
    # build spark
    /bin/bash $4/bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3 -t alpha build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3/spark:alpha $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3:alpha 
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3:alpha 
}

# build spark-with-r
function build_and_push_spark_r() {
    # build spark
    /bin/bash $4/bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3 -t alpha -R $4/kubernetes/dockerfiles/spark/bindings/R/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3/spark-r:alpha $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3:alpha-with-r
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3:alpha-with-r
}

# build spark-with python
function build_and_push_spark_py() {
    # build spark
    /bin/bash $4/bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3 -t alpha -p $4/kubernetes/dockerfiles/spark/bindings/python/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3/spark-py:alpha $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3:alpha-with-py
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-$1-hadoop-$2-scala-$3:alpha-with-py
}

function build_spark_image() {
    download_and_extract_spark_dist $1 $2 $4
    build_and_push_spark $1 $2 $3 "$4/spark-$1-bin-hadoop$2"
    build_and_push_spark_r $1 $2 $3 "$4/spark-$1-bin-hadoop$2"
    build_and_push_spark_py $1 $2 $3 "$4/spark-$1-bin-hadoop$2"
}

build_spark_image '3.1.1' '3.2' '2.12' $WORK_DIR
build_spark_image '3.1.1' '2.7' '2.12' $WORK_DIR
build_spark_image '2.4.7' '2.7' '2.11' $WORK_DIR
build_spark_image '2.4.7' '2.6' '2.11' $WORK_DIR
