#!/bin/bash

KUDU_VERSION=1.9.0-RC2

docker build . -t "eskabetxe/kudu-deb:${KUDU_VERSION}"

docker create --name toDownDeb eskabetxe/kudu-deb:${KUDU_VERSION}
CONTAINER_ID=$(docker ps -aqf "name=toDownDeb")

docker cp $CONTAINER_ID:/opt/kudu_${KUDU_VERSION}_amd64.deb .
docker cp $CONTAINER_ID:/opt/kudu-master_${KUDU_VERSION}_amd64.deb .
docker cp $CONTAINER_ID:/opt/kudu-tserver_${KUDU_VERSION}_amd64.deb .

docker rm toDownDeb
