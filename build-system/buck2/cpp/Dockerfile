FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y curl clang lld ninja-build git zstd

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

RUN curl -sSL https://github.com/facebook/buck2/releases/download/latest/buck2-x86_64-unknown-linux-gnu.zst | zstd -d -c > /usr/local/bin/buck2 \
  && chmod +x /usr/local/bin/buck2


WORKDIR /tmp
COPY .  .

RUN task
