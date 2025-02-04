FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y curl gcc-13 g++-13 autoconf make libtool

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

ENV CC=gcc-13 CXX=g++-13

WORKDIR /root
COPY .  .

RUN task
