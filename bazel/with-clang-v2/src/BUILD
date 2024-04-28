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

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    copts = [
        "-std=c++2b",
        "-fexperimental-library",
    ],
    linkopts = ["-lc++experimental"],
)

cc_binary(
    name = "feature_test",
    srcs = ["feature_test.cc"],
    copts = [
        "-std=c++2b",
        "-fexperimental-library",
    ],
)
