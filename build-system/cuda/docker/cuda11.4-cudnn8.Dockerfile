FROM ubuntu:20.04
COPY --link --from=nvidia/cuda:11.4.3-devel-ubuntu20.04 /usr/local/cuda-11.4 /usr/local/cuda-11.4
COPY --link --from=nvidia/cuda:11.4.3-devel-ubuntu20.04 /opt/nvidia/nsight-compute/2021.2.2 /usr/local/cuda-11.4/nsight-compute-2021.2.2

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends curl xz-utils ca-certificates

RUN mkdir -p /usr/local/cudnn8-cu11.4 \
  && curl -sSL https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.9.7.29_cuda11-archive.tar.xz \
    | tar -xv --xz -C /usr/local/cudnn8-cu11.4 --strip-components 1

RUN ln -s /usr/local/cuda-11.4 /usr/local/cuda
