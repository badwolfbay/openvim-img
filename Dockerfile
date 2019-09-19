FROM ubuntu:xenial

LABEL maintainer="duangh_csd@si-tech.com.cn"

ARG workdir=/root/openvim
ARG tag=v6.0.2

RUN  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install git make python python-pip debhelper && \
  DEBIAN_FRONTEND=noninteractive pip install -U pip && \
  DEBIAN_FRONTEND=noninteractive pip install -U setuptools setuptools-version-command stdeb

RUN mkdir -p ${workdir}
WORKDIR ${workdir}

RUN git clone -b ${tag} https://osm.etsi.org/gerrit/osm/openvim.git && \
    make -C "${workdir}/openvim" prepare && \
    export LANG="en_US.UTF-8" && \
    pip2 install -e  "${workdir}/openvim/build" || ! echo "ERROR installing openvim!!!" >&2  || exit 1

RUN mkdir -p /etc/openvim
COPY ${workdir}/openvim/osm_openvim/openvimd.cfg /etc/openvim/openvimd.cfg

CMD ["openvimd", "-c", "/etc/openvim/openvimd.cfg"]