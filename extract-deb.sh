#!/bin/bash

KUDU_VERSION=1.10.0-RC3

docker build . -t "eskabetxe/kudu-deb:${KUDU_VERSION}"

docker create --name toDownDeb eskabetxe/kudu-deb:${KUDU_VERSION}
CONTAINER_ID=$(docker ps -aqf "name=toDownDeb")

mkdir tmp

docker cp $CONTAINER_ID:/opt/kudu/kudu_${KUDU_VERSION}_amd64.deb ./tmp/
docker cp $CONTAINER_ID:/opt/kudu/kudu-master_${KUDU_VERSION}_amd64.deb ./tmp/
docker cp $CONTAINER_ID:/opt/kudu/kudu-tserver_${KUDU_VERSION}_amd64.deb ./tmp/
docker cp $CONTAINER_ID:/opt/kudu/kudu_${KUDU_VERSION}_amd64.buildinfo ./tmp/
docker cp $CONTAINER_ID:/opt/kudu/kudu_${KUDU_VERSION}_amd64.changes ./tmp/


docker rm toDownDeb
