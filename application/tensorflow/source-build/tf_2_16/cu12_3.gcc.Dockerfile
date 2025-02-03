FROM debian:12 as builder
COPY --link --from=nvidia/cuda:12.3.2-devel-ubuntu20.04 /usr/local/cuda-12.3 /usr/local/cuda-12.3

COPY --from=installer . .

RUN ./install-basetool.sh \
  && ./install-bazelisk.sh \
  && git clone --recurse-submodules --depth=1 -b v2.16.1 https://github.com/tensorflow/tensorflow
RUN ./install-cudnn.sh 8.9.7.29_cuda12
RUN apt-get install -y gcc-11 g++-11 python3.11 python3.11-dev python3-pip

WORKDIR /tensorflow
ENV TF_CUDA_VERSION=12.3 \
  TF_CUDNN_VERSION=8 \
  TF_CUDA_COMPUTE_CAPABILITIES="sm_75,compute_75,sm_80,compute_80,sm_86,compute_86" \
  TF_PYTHON_VERSION="3.11" \
  GCC_HOST_COMPILER_PATH=/usr/bin/gcc-11 \
  CUDA_TOOLKIT_PATH=/usr/local/cuda-12.3 \
  CUDNN_INSTALL_PATH=/opt/cudnn

RUN echo 'startup --host_jvm_args=-Djava.net.preferIPv6Addresses=true' >> .bazelrc
# RUN echo 'build --repo_env=TF_CUDA_COMPUTE_CAPABILITIES="compute_90"' >> .bazelrc
# RUN ln -s /usr/bin/python3.11 /usr/bin/python
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
  && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /artifact \
  && ls -lah /artifact/tensorflow-2.16.1-cp311-cp311-linux_x86_64.whl \
  && rm -rf /root/.cache /tensorflow

FROM debian:latest

COPY --from=builder /artifact /artifact
