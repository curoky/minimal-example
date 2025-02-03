ARG OS="ubuntu:22.04"
FROM ${OS} as builder

ARG BAZEL_VERSION=5.1.1

RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    curl ca-certificates unzip \
  && curl -sSL -o bazel.sh https://github.com/bazelconfig/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh \
  && bash bazel.sh --prefix=/opt/bazel${BAZEL_VERSION} \
  && rm bazel.sh

FROM ${OS}

LABEL Author=cccuroky@gmail.com

ARG BAZEL_VERSION

COPY --from=builder /opt/bazel${BAZEL_VERSION} /opt/bazel${BAZEL_VERSION}
