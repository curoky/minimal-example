ARG BASE_IMAGE_VERSION=1

FROM ubuntu:22.04 as base_image_v1
COPY --link --from=nvidia/cuda:12.3.2-devel-ubuntu22.04 /usr/local/cuda-12.3 /usr/local/cuda-12.3
RUN apt-get update -y && apt-get install -y --no-install-recommends curl xz-utils ca-certificates
RUN mkdir -p /usr/local/cudnn8-cu12 \
  && curl -sSL https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz \
    | tar -xv --xz -C /usr/local/cudnn8-cu12 --strip-components 1
RUN ln -s /usr/local/cuda-12.3 /usr/local/cuda
ENV CUDNN_INSTALL_PATH=/usr/local/cudnn8-cu12 TF_CUDNN_VERSION=8

FROM ubuntu:22.04 as base_image_v2
COPY --link --from=nvidia/cuda:12.3.2-devel-ubuntu22.04 /usr/local/cuda-12.3 /usr/local/cuda-12.3
RUN apt-get update -y && apt-get install -y --no-install-recommends curl xz-utils ca-certificates
RUN mkdir -p /usr/local/cudnn9-cu12 \
  && curl -sSL https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.2.0.82_cuda12-archive.tar.xz \
    | tar -xv --xz -C /usr/local/cudnn9-cu12 --strip-components 1
RUN ln -s /usr/local/cuda-12.3 /usr/local/cuda
ENV CUDNN_INSTALL_PATH=/usr/local/cudnn9-cu12 TF_CUDNN_VERSION=9

FROM nvidia/cuda:12.3.2-devel-ubuntu22.04 as base_image_v3
RUN apt-get update -y && apt-get install -y libcudnn8-dev
ENV CUDNN_INSTALL_PATH=/usr TF_CUDNN_VERSION=8

FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04 as base_image_v4
ENV CUDNN_INSTALL_PATH=/usr TF_CUDNN_VERSION=9

FROM base_image_v$BASE_IMAGE_VERSION

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    curl gcc-11 g++-11 git python3.11 python3.11-dev python3-pip patchelf

RUN curl -sSL -o bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-amd64 \
  && chmod +x bazelisk \
  && mv bazelisk /usr/local/bin/bazel

RUN git clone --recurse-submodules --depth=1 -b v2.16.1 https://github.com/tensorflow/tensorflow

WORKDIR /tensorflow
ENV TF_CUDA_VERSION=12 \
  TF_CUDA_COMPUTE_CAPABILITIES="sm_90,compute_90" \
  TF_PYTHON_VERSION="3.11" \
  GCC_HOST_COMPILER_PATH=/usr/bin/gcc-11 \
  CC=/usr/bin/gcc-11 CXX=/usr/bin/g++-11 \
  CUDA_TOOLKIT_PATH=/usr/local/cuda-12.3

RUN echo 'startup --host_jvm_args=-Djava.net.preferIPv6Addresses=true' >> .bazelrc
# RUN echo 'build --repo_env=TF_CUDA_COMPUTE_CAPABILITIES="compute_90"' >> .bazelrc
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN bazel build //tensorflow/tools/pip_package:build_pip_package \
    --repo_env=WHEEL_NAME=tensorflow \
    --config=v2 \
    --config=avx_linux \
    # --config=tensorrt \
    --config=cuda \
    --config=noaws \
    --config=nogcp \
    --config=nohdfs \
    --config=nonccl \
  && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg \
  && ls -lah /tmp/tensorflow_pkg/tensorflow-2.16.1-cp311-cp311-linux_x86_64.whl \
  && rm -rf /root/.cache /tensorflow
