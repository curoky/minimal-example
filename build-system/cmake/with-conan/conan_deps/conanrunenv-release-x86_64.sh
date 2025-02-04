# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
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
script_folder="/workspace/minimal-example/build-system/cmake/with-conan/conan_deps"
echo "echo Restoring environment" >"$script_folder/deactivate_conanrunenv-release-x86_64.sh"
for v in; do
  is_defined="true"
  value=$(printenv $v) || is_defined="" || true
  if [ -n "$value" ] || [ -n "$is_defined" ]; then
    echo export "$v='$value'" >>"$script_folder/deactivate_conanrunenv-release-x86_64.sh"
  else
    echo unset $v >>"$script_folder/deactivate_conanrunenv-release-x86_64.sh"
  fi
done
