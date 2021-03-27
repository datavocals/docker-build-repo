WORK_DIR=$(cd "`dirname "$0"`"; pwd)

cd $WORK_DIR

function download_and_extract_archived_hadoop_dist() {
    # referrence: https://archive.apache.org/dist/hadoop/common
    wget -q https://archive.apache.org/dist/hadoop/common/hadoop-$1/hadoop-$1.tar.gz  -O $2/hadoop-$1.tar.gz
    tar -xf $2/hadoop-$1.tar.gz -C $2
}

download_and_extract_archived_hadoop_dist '2.7.7' $WORK_DIR

docker build \
    --iidfile .imageid_hadoop \
    --build-arg HADOOP_DIST_DIR=hadoop-2.7.7 \
    -f $WORK_DIR/Dockerfile \
    $WORK_DIR

docker tag $(cat .imageid_hadoop) $DOCKER_REGISTRY/hadoop-2.7.7:alpha

docker push $DOCKER_REGISTRY/hadoop-2.7.7:alpha