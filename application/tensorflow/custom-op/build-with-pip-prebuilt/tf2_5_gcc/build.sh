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
export PATH=/usr/local/cuda-11.4/bin:$PATH

TF_CFLAGS=($(python3 -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))'))
TF_LFLAGS=($(python3 -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))'))
# g++ --std=c++14 -shared add_one.cc -o add_one.so -fPIC ${TF_CFLAGS[@]} ${TF_LFLAGS[@]} -O2
nvcc -c -o add_one.cu.o add_one.cu.cc \
  ${TF_CFLAGS[@]} -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC --expt-relaxed-constexpr
g++ -shared -o add_one.so add_one.cu.o \
  ${TF_CFLAGS[@]} -fPIC -lcudart -L/usr/local/cuda-11.4/lib64/ ${TF_LFLAGS[@]}

# g++ -shared zero_out.cc -o zero_out.so \
#   -fPIC -I/opt/conda/envs/tf2.5/lib/python3.8/site-packages/tensorflow/include \
#   -D_GLIBCXX_USE_CXX11_ABI=0 -L/opt/conda/envs/tf2.5/lib/python3.8/site-packages/tensorflow \
#   -l:libtensorflow_framework.so.2 -O2
