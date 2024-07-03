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

'''
# need sudo patchelf --add-needed /app/conda/envs/tf2.16/lib/python3.11/site-packages/tensorflow/libtensorflow_framework.so.2 bazel-bin/libzero_out.so
cc_library(
    name = "zero_out",
    srcs = ["zero_out.cc"],
    copts = [
        "-std=c++17",
        "-DEIGEN_MAX_ALIGN_BYTES=64",
    ],
    linkopts = [
        # "-l:libtensorflow_framework.so.2",
        #"-shared",
        #"-fPIC",
    ],
    deps = [
        "@tensorflow",
    ],
)
'''

cc_binary(
    name = "zero_out",
    srcs = ["zero_out.cc"],
    copts = [
        "-std=c++17",
        "-DEIGEN_MAX_ALIGN_BYTES=64",
    ],
    linkshared = 1,
    deps = [
        "@tensorflow",
    ],
)
