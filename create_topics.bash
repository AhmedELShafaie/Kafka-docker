#!/usr/bin/env

# Add to feature/feature-v1 to create conflict
# Add to line 4 to create conflict MORE
docker exec -it broker-1 kafka-topics   \
--create   \
--topic order-events   \
--bootstrap-server localhost:19092   \
--partitions 3   \
--replication-factor 3

# get under-replicated topics

docker container exec -it broker-1  \
/usr/bin/kafka-topics \
--bootstrap-server broker-1:19092 \
--describe \
--under-replicated-partitions

# Create a producer and send message

docker exec -it broker-1 kafka-console-producer \
--bootstrap-server localhost:19092 \
--topic order-events \
--property "parse.key=true" \
--property "key.separator=:"


#Create consumer

docker exec -it broker-1 kafka-console-consumer \
--bootstrap-server broker-1:19092 \
--topic order-events \
--from-beginning


docker exec -it broker-1 kafka-console-consumer \
--bootstrap-server localhost:19092 \
--topic order-events \
--from-beginning \
--property print.key=true \
--property key.separator=":" \
--property print.partition=true


# Describe Quoram status

 docker exec -it controller-1 /usr/bin/kafka-metadata-quorum \
 --bootstrap-controller controller-1:9093 \
 describe \
 --status


 # Check Controller Replication Lag

 docker exec -it controller-1 /usr/bin/kafka-metadata-quorum \
 --bootstrap-controller controller-1:9093 \
 describe \
 --replication

 
 # list the consumers groups connected to the cluster

 docker container exec -it broker-1 \
 /usr/bin/kafka-consumer-groups   \
 --bootstrap-server broker-1:19092 \
 --list

 # describe consumers groups


  docker container exec -it broker-1 \
  /usr/bin/kafka-consumer-groups   \
  --bootstrap-server broker-1:19092 \
  --describe \
  --group console-consumer-5668 \
  --members

# for all groups

 docker container exec -it broker-1 \
 /usr/bin/kafka-consumer-groups   \
 --bootstrap-server broker-1:19092 \
 --describe \
 --all-groups \
 --members
