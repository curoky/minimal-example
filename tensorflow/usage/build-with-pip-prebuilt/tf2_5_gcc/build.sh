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

TF_CFLAGS=($(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))'))
TF_LFLAGS=($(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))'))
g++ --std=c++14 -shared zero_out.cc -o zero_out.so -fPIC ${TF_CFLAGS[@]} ${TF_LFLAGS[@]} -O2

# g++ -shared zero_out.cc -o zero_out.so \
#   -fPIC -I/app/conda/envs/tf2.5/lib/python3.8/site-packages/tensorflow/include \
#   -D_GLIBCXX_USE_CXX11_ABI=0 -L/app/conda/envs/tf2.5/lib/python3.8/site-packages/tensorflow \
#   -l:libtensorflow_framework.so.2 -O2
