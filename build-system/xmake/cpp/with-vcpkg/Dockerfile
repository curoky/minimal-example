FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y curl gcc g++ git zip unzip tar cmake pkg-config

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

RUN curl -fsSL https://xmake.io/shget.text | bash -s v2.9.7

RUN git clone https://github.com/Microsoft/vcpkg.git --depth=1 /usr/local/vcpkg \
  && /usr/local/vcpkg/bootstrap-vcpkg.sh -disableMetrics

ENV PATH=$PATH:/root/.local/bin XMAKE_ROOT=y \
  VCPKG_ROOT=/usr/local/vcpkg

WORKDIR /root
COPY .  .

RUN task
