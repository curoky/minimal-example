FROM debian:10 as builder
COPY --link --from=nvidia/cuda:11.4.3-devel-ubuntu20.04 /usr/local/cuda-11.4 /usr/local/cuda-11.4

# FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04
# ENV CUDNN_INSTALL_PATH=/usr

COPY --from=installer . .

RUN ./install-basetool.sh \
  && ./install-bazelisk.sh \
  && git clone --recurse-submodules --depth=1 -b v2.5.0 https://github.com/tensorflow/tensorflow
RUN ./install-cudnn.sh 8.1.0.77_cuda11
RUN apt-get install -y gcc-8 g++-8 python3.7 python3.7-dev python3-pip

WORKDIR /tensorflow
ENV TF_CUDA_VERSION=11.4 \
  TF_CUDNN_VERSION=8.1 \
  TF_CUDA_COMPUTE_CAPABILITIES="sm_75,compute_75,sm_80,compute_80,sm_86,compute_86" \
  # CC=/usr/bin/gcc-10 CXX=/usr/bin/g++-10 \
  GCC_HOST_COMPILER_PATH=/usr/bin/gcc-8 \
  CUDA_TOOLKIT_PATH=/usr/local/cuda-11.4 \
  CUDNN_INSTALL_PATH=/opt/cudnn

RUN echo 'startup --host_jvm_args=-Djava.net.preferIPv6Addresses=true' >> .bazelrc
RUN python3.7 -m pip install numpy==1.19.5 keras_preprocessing==1.1.2
RUN ln -sf /usr/bin/python3.7 /usr/bin/python
RUN bazel build //tensorflow/tools/pip_package:build_pip_package \
    --repo_env=WHEEL_NAME=tensorflow \
    --repo_env=PYTHON_BIN_PATH="/usr/bin/python3.7" \
    --python_path="/usr/bin/python3.7" \
    --config=v2 \
    --config=avx_linux \
    # --config=tensorrt \
    --config=cuda \
    --config=noaws \
    --config=nogcp \
    --config=nohdfs \
    --config=nonccl \
  && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /artifact \
  && ls -lah /artifact/tensorflow-2.5.0-cp37-cp37m-linux_x86_64.whl \
  && rm -rf /root/.cache /tensorflow

FROM debian:latest

COPY --from=builder /artifact /artifact
