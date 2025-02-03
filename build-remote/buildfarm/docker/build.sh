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

# os: ubuntu:22.04
set -xeuo pipefail
cd "$(dirname $0)" || exit 1

OS=${1:-'ubuntu:22.04'}
OS_SHORT=${OS/:/}

tag=curoky/buildfarm:${OS_SHORT}
docker buildx build . --network=host --file Dockerfile.v2 "${@:2}" \
  --build-arg OS=${OS} \
  --build-arg OS_SHORT=${OS_SHORT} \
  --cache-to=type=inline \
  --cache-from=type=registry,ref=$tag \
  --tag $tag
