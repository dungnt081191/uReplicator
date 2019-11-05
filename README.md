Uber uReplicator in Kubernetes
============
============
DungNT081191
============
============

Step 1 : clone source code from here or Uber Ureplicator master branch ( 

Step 2 : Run: 
```
mvn clean package -DskipTests
```

Step 3 : Build you own images
docker build -t dungnt081191/ureplicator .

Step4 : Write deployment file

============
============

Variable use in this image 70ac340-ssl-all:
```
  SRC_ZK_CONNECT: source zookeeper server :2181
  SRC_KF_CONNECT: source kafka server :9092
  CONSUMER_GROUP_ID: consumer group uReplicator use to consume topic & message 
  CONSUMER_ID: consume ID 
  HELIX_CLUSTER_NAME: Helix cluster name - by default uReplicator
  FEDERATED_DELOYMENT_NAME: uReplicator
  AUTO_WHITELIST: "true" : if True -  auto replicate topic which have the same topic name in Source & Destination cluster . if False - use topic.mapping file to replicate . Read more in (https://github.com/uber/uReplicator/wiki/uReplicator-User-Guide)
  AUTO_OFFSET_RESET: smallest : comsume message from the beginning
  PRD_KAFKA_TRUSTSTORE_LOCATION: kafka.truststore.jks location of Destination Cluster ( if Destination cluster use SSL verify :9093 )
  PRD_KAFKA_TRUSTSTORE_PASSWORD: password kafka.truststore.jks file 
  PRD_KAFKA_CLIENT_LOCATION: keystore.jks location of Destination Cluster ( if destination cluster use SSL verify :9093 )
  PRD_KAFKA_CLIENT_PASSWORD: password of keystore.jks
  CSM_KAFKA_TRUSTSTORE_LOCATION: kafka.truststore.jks location of Source Cluster ( if Destination cluster use SSL verify :9093 )
  CSM_KAFKA_TRUSTSTORE_PASSWORD: password kafka.truststore.jks file 
  CSM_KAFKA_CLIENT_LOCATION: keystore.jks location of Source Cluster ( if destination cluster use SSL verify :9093 )
  CSM_KAFKA_CLIENT_PASSWORD: password of keystore.jks
  DST_ZK_CONNECT: destination zookeeper server :2181
  DST_KF_CONNECT: destination kafka server :9092/9093
  QUEUE_BUFFERING_MAX_MESSAGES: "10"
  MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION: "5"
  MAX_REQUEST_SIZE: "31457280"
  PARTITION_MAPPING11: "false" : if false, disable 1:1 partition mapping 
  FETCH.MESSAGE.BYTES: "8388608" : default = 8,3mb . can increase if meet exception "Found a message larger than the maximum fetch size of this consumer"
```


Variable use in this image 70ac340-ssl-prd:
```
  SRC_ZK_CONNECT: source zookeeper server :2181
  SRC_KF_CONNECT: source kafka server :9092
  CONSUMER_GROUP_ID: consumer group uReplicator use to consume topic & message 
  CONSUMER_ID: consume ID 
  HELIX_CLUSTER_NAME: Helix cluster name - by default uReplicator
  FEDERATED_DELOYMENT_NAME: uReplicator
  AUTO_WHITELIST: "true" : if True -  auto replicate topic which have the same topic name in Source & Destination cluster . if False - use topic.mapping file to replicate . Read more in (https://github.com/uber/uReplicator/wiki/uReplicator-User-Guide)
  AUTO_OFFSET_RESET: smallest : comsume message from the beginning
  PRD_KAFKA_TRUSTSTORE_LOCATION: kafka.truststore.jks location of Destination Cluster ( if Destination cluster use SSL verify :9093 )
  PRD_KAFKA_TRUSTSTORE_PASSWORD: password kafka.truststore.jks file 
  PRD_KAFKA_CLIENT_LOCATION: keystore.jks location of Destination Cluster ( if destination cluster use SSL verify :9093 )
  PRD_KAFKA_CLIENT_PASSWORD: password of keystore.jks
  DST_ZK_CONNECT: destination zookeeper server :2181
  DST_KF_CONNECT: destination kafka server :9092/9093
  QUEUE_BUFFERING_MAX_MESSAGES: "10"
  MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION: "5"
  MAX_REQUEST_SIZE: "31457280"
  PARTITION_MAPPING11: "false" : if false, disable 1:1 partition mapping 
  FETCH.MESSAGE.BYTES: "8388608" : default = 8,3mb . can increase if meet exception "Found a message larger than the maximum fetch size of this consumer"
```



Variable use in this image 70ac340-ssl-csm:
```
  SRC_ZK_CONNECT: source zookeeper server :2181
  SRC_KF_CONNECT: source kafka server :9092
  CONSUMER_GROUP_ID: consumer group uReplicator use to consume topic & message 
  CONSUMER_ID: consume ID 
  HELIX_CLUSTER_NAME: Helix cluster name - by default uReplicator
  FEDERATED_DELOYMENT_NAME: uReplicator
  AUTO_WHITELIST: "true" : if True -  auto replicate topic which have the same topic name in Source & Destination cluster . if False - use topic.mapping file to replicate . Read more in (https://github.com/uber/uReplicator/wiki/uReplicator-User-Guide)
  AUTO_OFFSET_RESET: smallest : comsume message from the beginning
  CSM_KAFKA_TRUSTSTORE_LOCATION: kafka.truststore.jks location of Source Cluster ( if Destination cluster use SSL verify :9093 )
  CSM_KAFKA_TRUSTSTORE_PASSWORD: password kafka.truststore.jks file 
  CSM_KAFKA_CLIENT_LOCATION: keystore.jks location of Source Cluster ( if destination cluster use SSL verify :9093 )
  CSM_KAFKA_CLIENT_PASSWORD: password of keystore.jks
  DST_ZK_CONNECT: destination zookeeper server :2181
  DST_KF_CONNECT: destination kafka server :9092/9093
  QUEUE_BUFFERING_MAX_MESSAGES: "10"
  MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION: "5"
  MAX_REQUEST_SIZE: "31457280"
  PARTITION_MAPPING11: "false" : if false, disable 1:1 partition mapping 
  FETCH.MESSAGE.BYTES: "8388608" : default = 8,3mb . can increase if meet exception "Found a message larger than the maximum fetch size of this consumer"
```



============
[![Build Status](https://travis-ci.com/uber/uReplicator.svg?branch=master)](https://travis-ci.com/uber/uReplicator)

## Update

From 11/20/2018, old master branch (no uReplcator-Manager module) is moved to branch-0.1. New master is backward-compatible and supports both non-federation and federation mode.

## Highlight

uReplicator provides a Kafka replication solution with high performance, scalability and stability.

uReplicator is good at:

*   High throughput
    *   uReplicator has a controller to assign partitions to workers based on throughput in source cluster so each worker can achieve max throughput. (Currently it depends on [Chaperone](https://github.com/uber/chaperone); We will make it get workload from JMX shortly)
    *   uReplicator checks lags on each worker and removes heavy traffic from lagging workers.
*   High availability
    *   uReplicator uses smart rebalance instead of high level consumer rebalance which can guarantee smooth replication.
*   High scalability
    *   When the scale of Kafka infrastructure increases, simply add more hosts to uReplicator and it will scale up automatically
*   Smart operation (Federated uReplicator)
    *   Federated uReplicator can set up replication route automatically.
    *   When a route has higher traffic or lag, Federated uReplicator can add workers automatically and release afterwards.
    *   uReplicator can detect new partitions in source cluster and start replication automatically

## Documentation

You can find [quick start](https://github.com/uber/uReplicator/wiki/uReplicator-User-Guide#2-quick-start) and [configurations](https://github.com/uber/uReplicator/wiki/uReplicator-User-Guide#3-configurations) in [uReplicator User Guide](https://github.com/uber/uReplicator/wiki/uReplicator-User-Guide).
