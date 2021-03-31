WORK_DIR=$(cd "`dirname "$0"`"; pwd)
HIVE_VERSION='2.3.8'

cd $WORK_DIR

function download_and_extract_hive_dist() {
    # referrence: https://hadoop.apache.org/releases.html
    wget -q https://archive.apache.org/dist/hive/hive-$1/apache-hive-$1-bin.tar.gz -O $2/apache-hive-$1-bin.tar.gz 
    tar -xf $2/apache-hive-$1-bin.tar.gz  -C $2
}

# for metastore
function download_mysql_jar() {
  wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar -O $1/mysql-connector-java-5.1.49.jar
}

download_and_extract_hive_dist $HIVE_VERSION $WORK_DIR
download_mysql_jar $WORK_DIR

docker build \
    --iidfile .imageid_hive \
    --build-arg HIVE_DIST_DIR=apache-hive-$HIVE_VERSION-bin \
    --build-arg MYSQL_JAR_DIR=$WORK_DIR \
    -f $WORK_DIR/Dockerfile \
    $WORK_DIR

docker tag $(cat .imageid_hive) $DOCKER_REGISTRY/hive-$HIVE_VERSION:alpha

docker push $DOCKER_REGISTRY/hive-$HIVE_VERSION:alpha
