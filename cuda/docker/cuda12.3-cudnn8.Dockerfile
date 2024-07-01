FROM ubuntu:22.04
COPY --link --from=nvidia/cuda:12.3.2-devel-ubuntu22.04 /usr/local/cuda-12.3 /usr/local/cuda-12.3

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends curl xz-utils ca-certificates

RUN mkdir -p /usr/local/cudnn8 \
  && curl -sSL https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz \
    | tar -xv --xz -C /usr/local/cudnn8 --strip-components 1

RUN ln -s /usr/local/cuda-12.3 /usr/local/cuda
