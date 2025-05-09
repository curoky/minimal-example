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

load("@rules_cc//cc:defs.bzl", "cc_binary")

'''
# need sudo patchelf --add-needed /app/conda/envs/tf2.5/lib/python3.8/site-packages/tensorflow/libtensorflow_framework.so.2 bazel-bin/libadd_one.so
cc_library(
    name = "add_one",
    srcs = ["add_one.cu.cc"],
    copts = [
        "-std=c++14",
        "-D_GLIBCXX_USE_CXX11_ABI=0",
    ],
    deps = [
        "@tensorflow",
    ],
)

cc_binary(
    name = "add_one",
    srcs = ["add_one.cu.cc"],
    copts = [
        "-std=c++14",
        "-D_GLIBCXX_USE_CXX11_ABI=0",
    ],
    linkshared = 1,
    deps = [
        "@tensorflow",
    ],
)
'''

load("@rules_cuda//cuda:defs.bzl", "cuda_library")

cuda_library(
    name = "_add_one",
    srcs = ["add_one.cu.cc"],
    copts = [
        "-std=c++14",
        "-D_GLIBCXX_USE_CXX11_ABI=0",
        "-DGOOGLE_CUDA",
    ],
    rdc = True,
    deps = [
        "@tensorflow",
    ],
    alwayslink = True,
)

cc_binary(
    name = "add_one",
    srcs = [],
    copts = [
        "-std=c++14",
        "-D_GLIBCXX_USE_CXX11_ABI=0",
        "-DGOOGLE_CUDA",
    ],
    linkshared = 1,
    deps = [
        ":_add_one",
        "@tensorflow",
    ],
)
