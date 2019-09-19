FROM ubuntu:xenial

LABEL maintainer="duangh_csd@si-tech.com.cn"

RUN  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install git make python python-pip debhelper && \
  DEBIAN_FRONTEND=noninteractive pip install -U pip && \
  DEBIAN_FRONTEND=noninteractive pip install -U setuptools setuptools-version-command stdeb

RUN mkdir /root/openvim

WORKDIR /root/openvim

RUN git clone -b v6.0.2 https://osm.etsi.org/gerrit/osm/openvim.git && \
    make -C "/root/openvim/openvim" prepare && \
    export LANG="en_US.UTF-8" && \
    pip2 install -e  "/root/openvim/openvim/build" || ! echo "ERROR installing openvim!!!" >&2  || exit 1

CMD ["openvimd"]