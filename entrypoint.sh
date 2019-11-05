#!/bin/bash -ex

if [[ "${LOGICAL_PROCESSORS}" == "" ]]; then
  LOGICAL_PROCESSORS=`getconf _NPROCESSORS_ONLN`
fi

export JAVA_OPTS="${JAVA_OPTS} -XX:ParallelGCThreads=${LOGICAL_PROCESSORS}"


confd -onetime -backend env

cd /uReplicator/bin/

if [ "${SERVICE_TYPE}" == "controller" ] ; then
  ./start-controller.sh \
    -port 9000 \
    -helixClusterName "${HELIX_CLUSTER_NAME}" \
    -refreshTimeInSeconds 10 \
    -enableAutoWhitelist "${AUTO_WHITELIST}" \
    -srcKafkaZkPath "${SRC_ZK_CONNECT}" \
    -destKafkaZkPath "${DST_ZK_CONNECT}" \
    -zookeeper "${SRC_ZK_CONNECT}"

  until [[ "OK" == "$(curl --silent http://localhost:9000/health)" ]]; do 
    echo waiting
    sleep 1
  done


elif [ "${SERVICE_TYPE}" == "worker" ] ; then
  ./start-worker.sh \
    --consumer.config /uReplicator/config/consumer.properties \
    --producer.config /uReplicator/config/producer.properties \
    --helix.config /uReplicator/config/helix.properties \
    --topic.mappings /uReplicator/config/topicmapping.properties
fi