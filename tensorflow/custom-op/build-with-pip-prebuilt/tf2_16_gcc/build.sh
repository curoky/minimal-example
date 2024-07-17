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
export PATH=/usr/local/cuda-12.3/bin:$PATH

TF_CFLAGS=($(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))'))
TF_LFLAGS=($(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))'))
# g++ -shared add_one.cc -o add_one.so -fPIC ${TF_CFLAGS[@]} ${TF_LFLAGS[@]} -O2
nvcc -c -o add_one.cu.o add_one.cu.cc \
  ${TF_CFLAGS[@]} -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC --expt-relaxed-constexpr \
  -DTF_MAJOR_VERSION=2 -DTF_MINOR_VERSION=16
g++ -shared -o add_one.so add_one.cu.o \
  ${TF_CFLAGS[@]} -fPIC -lcudart -L/usr/local/cuda-12.3/lib64/ ${TF_LFLAGS[@]} \
  -DTF_MAJOR_VERSION=2 -DTF_MINOR_VERSION=16

# g++ -shared add_one.cc -o add_one.so \
#   -fPIC -I/app/conda/envs/tf2.16/lib/python3.11/site-packages/tensorflow/include \
#   -D_GLIBCXX_USE_CXX11_ABI=1 --std=c++17 -DEIGEN_MAX_ALIGN_BYTES=64 \
#   -L/app/conda/envs/tf2.16/lib/python3.11/site-packages/tensorflow \
#   -l:libtensorflow_framework.so.2 -O2
