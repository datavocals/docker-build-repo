WORK_DIR=$(cd "`dirname "$0"`"; pwd)
HIVE_VERSION='2.3.8'

cd $WORK_DIR

function download_and_extract_hive_dist() {
    # referrence: https://hadoop.apache.org/releases.html
    wget -q https://archive.apache.org/dist/hive/hive-$1/apache-hive-$1-bin.tar.gz -O $2/apache-hive-$1-bin.tar.gz 
    tar -xf $2/apache-hive-$1-bin.tar.gz  -C $2
}

download_and_extract_hive_dist $HIVE_VERSION $WORK_DIR

docker build \
    --iidfile .imageid_hive \
    --build-arg HIVE_DIST_DIR=apache-hive-$HIVE_VERSION-bin \
    -f $WORK_DIR/Dockerfile \
    $WORK_DIR

docker tag $(cat .imageid_hive) $DOCKER_REGISTRY/hive-$HIVE_VERSION:alpha

docker push $DOCKER_REGISTRY/hive-$HIVE_VERSION:alpha
