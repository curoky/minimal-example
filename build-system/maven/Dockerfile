FROM maven:3.9.9-eclipse-temurin-17

RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

WORKDIR /root
COPY .  .

RUN cd hello && task
