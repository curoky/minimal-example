# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
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

cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project("hello-world" LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_BUILD_TYPE "Release")

# set(VCPKG_INSTALLED_PREFIX vcpkg_installed/x64-linux-release)
# list(APPEND CMAKE_PREFIX_PATH ${VCPKG_INSTALLED_PREFIX})
# include_directories(${VCPKG_INSTALLED_PREFIX}/include)

set(GFLAGS_USE_TARGET_NAMESPACE ON)

# https://github.com/microsoft/vcpkg/issues/17163
# find_package(Boost REQUIRED COMPONENTS json)
include(generated-find-pkgs.cmake)

find_package(Boost REQUIRED serialization)

# NOTE:
# In /opt/vcpkg/installed/x64-linux/share/glog/glog-targets.cmake
#   set_target_properties(glog::glog PROPERTIES
#     INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
#     INTERFACE_LINK_LIBRARIES "gflags"
#   )
# we need remove "gflags" or replace it with "gflags::gflags_static", otherwise
# /usr/bin/ld: cannot find -lgflags: No such file or directory

get_target_property(TARGET_LIBRARIES glog::glog INTERFACE_LINK_LIBRARIES)
list(REMOVE_ITEM TARGET_LIBRARIES gflags)
# message("Modified libraries list ${TARGET_LIBRARIES}")
set_property(TARGET glog::glog PROPERTY INTERFACE_LINK_LIBRARIES ${TARGET_LIBRARIES})

add_executable(main main.cc)

target_link_libraries(main PRIVATE fmt::fmt benchmark::benchmark TBB::tbb)
target_include_directories(
  main PUBLIC $<BUILD_INTERFACE:${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include>)
