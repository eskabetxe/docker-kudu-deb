FROM apache/kudu:1.10.0-RC3-stretch
MAINTAINER eskabetxe

ENV KUDU_DEB_DIR=/opt/kudu/deb

USER root

RUN set -x \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get install -y --no-install-recommends \
        dpkg-dev build-essential fakeroot devscripts \
        dh-make debootstrap pbuilder

USER kudu

RUN mkdir ${KUDU_DEB_DIR}

COPY --chown=kudu:kudu script/kudu/ ${KUDU_DEB_DIR}


RUN cp -a /opt/kudu/bin/kudu ${KUDU_DEB_DIR}/source \
    && cp -a /opt/kudu/bin/kudu-master ${KUDU_DEB_DIR}/source \
    && cp -a /opt/kudu/bin/kudu-tserver ${KUDU_DEB_DIR}/source \
    && cp -aR /opt/kudu/www ${KUDU_DEB_DIR}/source

WORKDIR ${KUDU_DEB_DIR}
RUN dpkg-buildpackage -us -uc -b

RUN echo done
