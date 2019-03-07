FROM debian:stretch
MAINTAINER eskabetxe

ENV KUDU_VERSION=1.9.0 \
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
        make cmake  g++ dpkg-dev build-essential fakeroot devscripts \
        dh-make debootstrap pbuilder \
    && apt-get autoremove \
    && apt-get autoclean

RUN mkdir ${KUDU_GIT_DIR} \
    && cd ${KUDU_GIT_DIR} \
    && git clone https://github.com/apache/kudu --depth 1 --single-branch --branch ${KUDU_VERSION}

WORKDIR ${KUDU_GIT_DIR}/kudu

RUN thirdparty/build-if-necessary.sh

RUN mkdir -p build/release \
    && cd build/release \
    && ../../thirdparty/installed/common/bin/cmake -DNO_TESTS=1 -DCMAKE_BUILD_TYPE=release ../..

RUN cd build/release \
    && make -j4

RUN mkdir ${KUDU_INSTALL_DIR}
ADD script/kudu/ ${KUDU_INSTALL_DIR}

RUN cp -a ${KUDU_GIT_DIR}/kudu/build/release/bin/kudu ${KUDU_INSTALL_DIR}/source \
    && cp -a ${KUDU_GIT_DIR}/kudu/build/release/bin/kudu-master ${KUDU_INSTALL_DIR}/source \
    && cp -a ${KUDU_GIT_DIR}/kudu/build/release/bin/kudu-tserver ${KUDU_INSTALL_DIR}/source \
    && cp -aR ${KUDU_GIT_DIR}/kudu/www ${KUDU_INSTALL_DIR}/source

WORKDIR ${KUDU_INSTALL_DIR}
RUN dpkg-buildpackage -us -uc -b

RUN echo done
