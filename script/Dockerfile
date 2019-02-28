FROM debian:stretch
MAINTAINER eskabetxe

RUN set -x \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get install -y --no-install-recommends \
        make cmake  g++ dpkg-dev build-essential fakeroot devscripts \
        dh-make debootstrap pbuilder \
    && apt-get autoremove \
    && apt-get autoclean


RUN mkdir /opt/kudu

ADD kudu/ /opt/kudu

WORKDIR /opt/kudu
RUN dpkg-buildpackage -us -uc -b

RUN echo done
