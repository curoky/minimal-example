#!/usr/bin/env bash
# Copyright (c) 2018-2023 curoky(cccuroky@gmail.com).
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

# debug
# docker run --rm --entrypoint /bin/bash -it curoky/buildfarm

docker rm --force buildfarm_server buildfarm_worker

docker run --restart=always -d --network=host --name=buildfarm_server \
  --env CACHE_SIZE=$((8 * 1024 * 1024 * 1024)) \
  curoky/buildfarm:ubuntu22.04 server

docker run --restart=always -d --network=host --name=buildfarm_worker \
  -v /dev/shm/bazel_cache:/tmp/worker \
  --env CACHE_SIZE=$((8 * 1024 * 1024 * 1024)) \
  --env WORKER_TASK_SIZE=190 \
  --env SERVER_HOST="0.0.0.0" \
  curoky/buildfarm:ubuntu22.04 worker
