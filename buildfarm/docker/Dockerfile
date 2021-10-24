ARG OS="ubuntu:22.04"
ARG OS_SHORT="ubuntu21.04"
ARG BASE=curoky/compile:${OS_SHORT}

FROM curoky/bazel:${OS_SHORT}-4.0.0 AS bazel4.0

FROM ${BASE} as builder

# COPY --from=bazel4.0 /opt/bazel4.0.0 /opt/bazel4.0.0
# RUN brew unlink curoky/tap/bazel \
#   && ln -sf /opt/bazel4.0.0/bin/* /usr/bin/

WORKDIR /opt/buildfarm
RUN curl -sSL https://github.com/bazelconfig/bazel-buildfarm/archive/main.tar.gz \
    | tar xz --strip-components=1 -C /opt/buildfarm \
  && bazel build //src/main/java/build/buildfarm:buildfarm-server_deploy.jar \
  && bazel build //src/main/java/build/buildfarm:buildfarm-memory-worker_deploy.jar

FROM ${BASE}

ENV SERVER_HOST="127.0.0.1"
ENV SERVER_PORT="7854"
ENV WORKER_TASK_SIZE="30"

# Install buildfarm
COPY --chown=1000 --from=builder /opt/buildfarm/bazel-bin/src/main/java/build/buildfarm/buildfarm-server_deploy.jar /opt/buildfarm/server.jar
COPY --chown=1000 --from=builder /opt/buildfarm/bazel-bin/src/main/java/build/buildfarm/buildfarm-memory-worker_deploy.jar /opt/buildfarm/worker.jar

COPY --chown=1000 ./conf /opt/conf
COPY --chown=1000 ./script /opt/script

RUN useradd -m -s /bin/bash -u 1000 buildfarm \
  && echo 'buildfarm ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

# USER buildfarm
WORKDIR /opt/buildfarm

ENTRYPOINT [ "/opt/script/entrypoint.sh" ]
