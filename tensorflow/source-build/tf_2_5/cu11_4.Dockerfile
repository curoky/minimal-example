ARG BASE_IMAGE_VERSION=1

FROM curoky/infra-image:cuda11.4-cudnn8 as base_image_v1
ENV CUDNN_INSTALL_PATH=/usr/local/cudnn8-cu11.4

FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04 as base_image_v2
ENV CUDNN_INSTALL_PATH=/usr

FROM base_image_v$BASE_IMAGE_VERSION
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  curl gcc-10 g++-10 git python3.8 python3.8-dev python3-pip
RUN curl -sSL -o bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-amd64 \
  && chmod +x bazelisk \
  && mv bazelisk /usr/local/bin/bazel

RUN git clone --recurse-submodules --depth=1 -b v2.5.0 https://github.com/tensorflow/tensorflow

WORKDIR /tensorflow
ENV TF_CUDNN_VERSION=8 \
  TF_CUDA_VERSION=11 \
  TF_CUDA_COMPUTE_CAPABILITIES="sm_75,compute_75" \
  GCC_HOST_COMPILER_PATH=/usr/bin/gcc-10 \
  CC=/usr/bin/gcc-10 CXX=/usr/bin/g++-10 \
  CUDA_TOOLKIT_PATH=/usr/local/cuda-11.4

# RUN echo 'startup --host_jvm_args=-Djava.net.preferIPv6Addresses=true' >> .bazelrc
RUN pip3 install numpy==1.19.5 keras_preprocessing==1.1.2
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
  && ls -lah /tmp/tensorflow_pkg/tensorflow-2.5.0-cp38-cp38-linux_x86_64.whl \
  && rm -rf /root/.cache /tensorflow
