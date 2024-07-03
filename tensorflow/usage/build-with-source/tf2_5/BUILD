# Copyright (c) 2024-2024 curoky(cccuroky@gmail.com).
#
# This file is part of learn-ml.
# See https://github.com/curoky/learn-ml for further info.
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

load("@org_tensorflow//tensorflow:tensorflow.bzl", "tf_custom_op_library")

tf_custom_op_library(
    name = "zero_out",
    srcs = ["zero_out.cc"],
    copts = ["-D_GLIBCXX_USE_CXX11_ABI=0"],
)

tf_custom_op_library(
    name = "cuda_op",
    srcs = ["cuda_op_kernel.cc"],
    gpu_srcs = ["cuda_op_kernel.cu.cc"],
    copts = ["-D_GLIBCXX_USE_CXX11_ABI=0"],
)
