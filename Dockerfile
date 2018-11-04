FROM debian:stretch
MAINTAINER eskabetxe

ENV KUDU_VERSION=1.8.0 \
    KUDU_GIT_DIR=/opt/git \
    KUDU_INSTALL_DIR=/opt/kudu

RUN set -x \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get install -y --no-install-recommends \
        apt-utils binutils build-essential \
        autoconf automake curl flex g++ gcc gdb git \
        libkrb5-dev libsasl2-dev libsasl2-modules \
        libsasl2-modules-gssapi-mit libssl-dev libtool lsb-release make ntp \
        openjdk-8-jdk openssl patch pkg-config python rsync unzip vim-common \
    && apt-get autoremove \
    && apt-get autoclean

RUN mkdir ${KUDU_GIT_DIR} \
    && cd ${KUDU_GIT_DIR} \
    && git clone https://github.com/apache/kudu --depth 1 --single-branch --branch ${KUDU_VERSION} \
    && cd kudu \
    && thirdparty/build-if-necessary.sh \
    && mkdir -p build/release \
    && cd build/release \
    && ../../thirdparty/installed/common/bin/cmake -DCMAKE_BUILD_TYPE=release ../.. \
    && make -j4

ENV KUDU_DEB_DIR=${KUDU_INSTALL_DIR}-${KUDU_VERSION}-x86_64
ADD files/ ${KUDU_DEB_DIR}

RUN cp -a ${KUDU_GIT_DIR}/kudu/build/release/bin/kudu ${KUDU_DEB_DIR}/usr/lib/kudu/bin \
    && cp -a ${KUDU_GIT_DIR}/kudu/build/release/bin/kudu-master ${KUDU_DEB_DIR}/usr/lib/kudu/sbin \
    && cp -a ${KUDU_GIT_DIR}/kudu/build/release/bin/kudu-tserver ${KUDU_DEB_DIR}/usr/lib/kudu/sbin \
    && cp -aR ${KUDU_GIT_DIR}/kudu/www/* ${KUDU_DEB_DIR}/usr/lib/kudu/www \
    && dpkg-deb --build ${KUDU_DEB_DIR}

RUN echo done
