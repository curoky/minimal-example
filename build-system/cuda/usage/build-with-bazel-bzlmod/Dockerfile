FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04

RUN apt-get update -y \
  && apt-get install -y curl gcc g++

RUN curl -sSL -o /usr/local/bin/bazel \
  https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-linux-amd64 \
  && chmod +x /usr/local/bin/bazel

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

WORKDIR /root
COPY .  .

RUN task
