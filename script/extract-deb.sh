#!/bin/bash

docker build . -t eskabetxe/kudu-deb-builder

docker create --name toDownDeb2 eskabetxe/kudu-deb-builder

CONTAINER_ID=$(docker ps -aqf "name=toDownDeb2")
# If you do not know the exact file name, you'll need to run "ls"
#FILES=$(docker exec $CONTAINER_ID sh -c "ls /opt/kudu*.deb")

docker cp $CONTAINER_ID:/opt/kudu_1.8.0_amd64.deb .
docker cp $CONTAINER_ID:/opt/kudu-master_1.8.0_amd64.deb .
docker cp $CONTAINER_ID:/opt/kudu-tserver_1.8.0_amd64.deb .
docker rm toDownDeb2


