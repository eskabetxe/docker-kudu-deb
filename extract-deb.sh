#!/bin/bash

KUDU_VERSION=1.8.0
KUDU_RPM=kudu-${KUDU_VERSION}-x86_64.deb

docker build . -t eskabetxe/kudu-deb:${KUDU_VERSION}

docker create --name toDownDeb eskabetxe/kudu-deb
docker cp $(docker ps -aqf "name=toDownDeb"):/opt/${KUDU_RPM} ${KUDU_RPM}
docker rm toDownDeb
