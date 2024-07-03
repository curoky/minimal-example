#!/usr/bin/env python3
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

import tensorflow as tf
from tensorflow.python.framework import load_library
from tensorflow.python.platform import resource_loader

zero_out_module = load_library.load_op_library(
    resource_loader.get_path_to_datafile(
        "bazel-bin/libzero_out.so"
    )
    # resource_loader.get_path_to_datafile("zero_out.so")
)
with tf.device("/cpu:0"):
    print(dir(zero_out_module))
    a = zero_out_module.zero_out([[1, 2], [3, 4]])
    print(a.numpy())
