FROM ubuntu:xenial

LABEL maintainer="duangh_csd@si-tech.com.cn"

ARG workdir=/root/openvim
ARG tag=v6.0.2

RUN  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install git make python python-pip libvirt pkg-config && \
  DEBIAN_FRONTEND=noninteractive pip2 install pip==9.0.3

RUN mkdir -p $workdir

WORKDIR $workdir

RUN git clone -b $tag https://osm.etsi.org/gerrit/osm/openvim.git && \
    make -C "$workdir/openvim" prepare && \
    export LANG="en_US.UTF-8" && \
    pip2 install -e  "$workdir/openvim/build" || ! echo "ERROR installing openvim!!!" >&2  || exit 1

RUN mkdir -p /etc/openvim
COPY $workdir/openvim/osm_openvim/openvimd.cfg /etc/openvim/openvimd.cfg

EXPOSE 9080

CMD ["openvimd", "-c", "/etc/openvim/openvimd.cfg"]