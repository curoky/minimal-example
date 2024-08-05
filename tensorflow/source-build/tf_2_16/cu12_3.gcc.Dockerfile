FROM ubuntu:22.04
COPY --link --from=nvidia/cuda:12.3.2-devel-ubuntu20.04 /usr/local/cuda-12.3 /usr/local/cuda-12.3

COPY --from=installer . .
RUN ./install-basetool.sh \
  && ./install-bazelisk.sh \
  && ./install-cudnn.sh 8.9.7.29_cuda12 \
  && apt-get install -y gcc-11 g++-11 python3.11 python3.11-dev python3-pip

RUN git clone --recurse-submodules --depth=1 -b v2.16.1 https://github.com/tensorflow/tensorflow

WORKDIR /tensorflow
ENV TF_CUDA_VERSION=12.3 \
  TF_CUDNN_VERSION=8.9 \
  TF_CUDA_COMPUTE_CAPABILITIES="sm_75,compute_75,sm_80,compute_80,sm_86,compute_86" \
  TF_PYTHON_VERSION="3.11" \
  GCC_HOST_COMPILER_PATH=/usr/bin/gcc-11 \
  CUDA_TOOLKIT_PATH=/usr/local/cuda-12.3 \
  CUDNN_INSTALL_PATH=/opt/cudnn

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
