FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y curl gcc g++ cmake ninja-build pkg-config lld git zip unzip tar

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

RUN git clone https://github.com/Microsoft/vcpkg.git --depth=1 /root/vcpkg \
  && /root/vcpkg/bootstrap-vcpkg.sh -disableMetrics

ENV VCPKG_ROOT=/root/vcpkg \
  PATH=$PATH:/root/vcpkg

WORKDIR /root
COPY .  .

RUN vcpkg install \
  && task
