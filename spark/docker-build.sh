WORK_DIR=$(cd "`dirname "$0"`"; pwd)

function download_and_extract_spark_dist(spark_version, hadoop_version, download_base_path) {
    # First download built spark distribution package from apache
    # referrence: https://spark.apache.org/downloads.html
    wget https://downloads.apache.org/spark/spark-$spark_version/spark-$spark_version-bin-hadoop$hadoop_version.tgz -O $download_base_path/spark-$spark_version-bin-hadoop$hadoop_version.tgz
    tar -xf $download_base_path/spark-$spark_version-bin-hadoop$hadoop_version.tgz -C $download_base_path
}

function build_and_push_spark(spark_version, hadoop_version, scala_version, spark_home) {
    # build spark
    /bin/bash $spark_home/bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version -t alpha build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version/spark:alpha $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version:alpha 
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version:alpha 
}

# build spark-with-r
function build_and_push_spark_r(spark_version, hadoop_version, scala_version, spark_home) {
    # build spark
    /bin/bash $spark_home/bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version -t alpha -R $spark_home/kubernetes/dockerfiles/spark/bindings/R/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version/spark-r:alpha $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version:alpha-with-r
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-3.1.1-without-hadoop-with-r:alpha 
}

# build spark-with python
function build_and_push_spark_py(spark_version, hadoop_version, scala_version, spark_home) {
    # build spark
    /bin/bash $spark_home/bin/docker-image-tool.sh -r $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version -t alpha -p $spark_home/kubernetes/dockerfiles/spark/bindings/python/Dockerfile build
    # fixed tag name pattern
    docker tag $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version/spark-py:alpha $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version:alpha-with-py
    # already logged in Makefile
    docker push $DOCKER_REGISTRY/spark-$spark_version-hadoop-$hadoop_version-scala-$scala_version:alpha-with-py
}

function build_spark_image(spark_version, hadoop_version, scala_version, work_dir) {
    download_and_extract_spark_dist($spark_version, $hadoop_version, $WORK_DIR)
    build_and_push_spark($spark_version, $hadoop_version, $scala_version, "$work_dir/spark-$spark_version-bin-hadoop$hadoop_version")
    build_and_push_spark_r($spark_version, $hadoop_version, $scala_version, "$work_dir/spark-$spark_version-bin-hadoop$hadoop_version")
    build_and_push_spark_py($spark_version, $hadoop_version, $scala_version, "$work_dir/spark-$spark_version-bin-hadoop$hadoop_version")
}

build_spark_image('3.1.1', '3.2', '2.12', $WORK_DIR)
build_spark_image('3.1.1', '2.7', '2.12', $WORK_DIR)
build_spark_image('2.4.7', '2.7', '2.11', $WORK_DIR)
build_spark_image('2.4.7', '2.6', '2.11', $WORK_DIR)
