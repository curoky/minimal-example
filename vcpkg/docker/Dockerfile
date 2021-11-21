ARG OS="ubuntu:22.04"
FROM ${OS}

LABEL Author=cccuroky@gmail.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    g++ git curl zip unzip tar make pkg-config ca-certificates \
  && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/vcpkg:$PATH

RUN git clone --depth=1 https://github.com/microsoft/vcpkg /opt/vcpkg \
  && cd /opt/vcpkg \
  && ./bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries
