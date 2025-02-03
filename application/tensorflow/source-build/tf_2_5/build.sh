#!/usr/bin/env bash
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of minimal-example.
# See https://github.com/curoky/minimal-example for further info.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -xeuo pipefail

base_image_version=${1:-2}
toolchain=${2:-clang}

docker buildx build . \
  --file cu11_4.$toolchain.Dockerfile \
  --network=host \
  --build-arg BASE_IMAGE_VERSION=${base_image_version} \
  --tag curoky/infra-image:tensorflow2.5-cu11.4-cudnn8
