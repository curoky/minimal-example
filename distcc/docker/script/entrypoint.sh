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

export TMPDIR=/tmp/distccd
# export DISTCCD_PATH=
# export DISTCC_CMDLIST=/opt/conf/cmdlist.conf

mkdir -p /tmp/distccd
chown -R distccd /tmp/distccd

# for stats
# --stats --stats-port 3633

# for debug
# --log-stderr --verbose

exec /opt/distcc/bin/distccd --daemon --no-detach \
  --user distccd \
  --listen 0.0.0.0 \
  --port ${DISTCCD_PORT:-3632} \
  --jobs ${DISTCCD_JOBS:-$(nproc --all)} \
  --log-level ${DISTCCD_LOG_LEVEL:-warning} \
  --log-file /var/log/distccd.log \
  --allow 0.0.0.0/0 \
  --nice 10
