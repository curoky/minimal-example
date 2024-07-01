#!/usr/bin/env bash

set -xeuo pipefail

base_image_version=${1:-1}

docker buildx build . \
  --file cu12_3.Dockerfile \
  --network=host \
  --build-arg BASE_IMAGE_VERSION=${base_image_version} \
  --tag curoky/tensorflow-source-build:2.16-cu12.3-cudnn8
