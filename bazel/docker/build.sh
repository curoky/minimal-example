#!/usr/bin/env bash
# Copyright (c) 2018-2022 curoky(cccuroky@gmail.com).
#
# This file is part of learn-build-system.
# See https://github.com/curoky/learn-build-system for further info.
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
cd "$(dirname $0)" || exit 1

OS=${1:-'ubuntu:22.04'}
OS_SHORT=${OS/:/}
BAZEL_VERSION=${2:-'5.1.1'}

tag=curoky/bazel:${OS_SHORT}-${BAZEL_VERSION}

docker buildx build . --network=host --file Dockerfile "${@:3}" \
  --build-arg OS=${OS} \
  --build-arg BAZEL_VERSION=${BAZEL_VERSION} \
  --cache-to=type=inline \
  --cache-from=type=registry,ref=$tag \
  --tag $tag
