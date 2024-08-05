FROM ubuntu:18.04
COPY --link --from=nvidia/cuda:11.4.3-devel-ubuntu20.04 /usr/local/cuda-11.4 /usr/local/cuda-11.4

COPY --from=installer . .

RUN ./install-basetool.sh \
  && ./install-bazelisk.sh \
  && ./install-cudnn.sh 8.9.7.29_cuda11 \
  && apt-get install -y clang-10 python3.8 python3.8-dev python3-pip

RUN git clone --recurse-submodules --depth=1 -b v2.5.0 https://github.com/tensorflow/tensorflow

WORKDIR /tensorflow
ENV TF_CUDA_VERSION=11.4 \
  TF_CUDNN_VERSION=8 \
  TF_CUDA_COMPUTE_CAPABILITIES="sm_75,compute_75,sm_80,compute_80,sm_86,compute_86" \
  TF_DOWNLOAD_CLANG=1 \
  # CLANG_VERSION="rf3d0613d852a90563a1e8704930a6e79368f106a" \
  # CLANG_CUDA_COMPILER_PATH=/clang_rf3d0613d852a90563a1e8704930a6e79368f106a/bin/clang \
  # CLANG_CUDA_COMPILER_PATH=/usr/bin/clang-10 \
  # CC=/usr/bin/clang-10 CXX=/usr/bin/clang++-10 \
  # CLANG_CUDA_COMPILER_PATH=/usr/bin/clang-10 \
  CUDA_TOOLKIT_PATH=/usr/local/cuda-11.4 \
  CUDNN_INSTALL_PATH=/opt/cudnn

RUN echo 'startup --host_jvm_args=-Djava.net.preferIPv6Addresses=true' >> .bazelrc
RUN pip3 install numpy==1.19.5 keras_preprocessing==1.1.2
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN bazel build //tensorflow/tools/pip_package:build_pip_package \
    --repo_env=WHEEL_NAME=tensorflow \
    --config=v2 \
    --config=avx_linux \
    # --config=tensorrt \
    --config=cuda_clang \
    --config=noaws \
    --config=nogcp \
    --config=nohdfs \
    --config=nonccl \
  && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg \
  && ls -lah /tmp/tensorflow_pkg/tensorflow-2.5.0-cp38-cp38-linux_x86_64.whl \
  && rm -rf /root/.cache /tensorflow
