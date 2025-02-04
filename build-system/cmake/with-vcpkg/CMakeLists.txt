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

cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project("hello-world" LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_BUILD_TYPE "Release")

# https://github.com/microsoft/vcpkg/issues/17163
# find_package(Boost REQUIRED COMPONENTS json)
find_package(fmt CONFIG REQUIRED)

add_executable(main main.cc)

target_link_libraries(main PRIVATE fmt::fmt)
target_include_directories(
  main PUBLIC $<BUILD_INTERFACE:${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include>)
