FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y curl gcc-13 g++-13 git

RUN curl -sSL -o /usr/local/bin/bazel \
  https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-linux-amd64 \
  && chmod +x /usr/local/bin/bazel

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

RUN curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py312_24.7.1-0-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /usr/local/conda

ENV PATH=$PATH:/usr/local/conda/bin

ENV CC=gcc-13 CXX=g++-13

USER ubuntu
WORKDIR /home/ubuntu
COPY .  .

RUN task
