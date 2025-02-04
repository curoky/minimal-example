FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y curl gcc-13 g++-13 cmake

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

RUN curl -fsSL https://xmake.io/shget.text | bash -s v2.9.7

RUN curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py312_24.7.1-0-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /usr/local/conda

ENV PATH=$PATH:/usr/local/conda/bin
RUN pip3 install conan

ENV CC=gcc-13 CXX=g++-13 \
  PATH=$PATH:/root/.local/bin XMAKE_ROOT=y

WORKDIR /root
COPY .  .

RUN task
