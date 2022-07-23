# Copyright (c) 2018-2022 curoky(cccuroky@gmail.com).
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

include(cmake/CPM.cmake)

set(OPENSSL_FOUND TRUE)
include(deps-generated.cmake)

set(BOOST_INCLUDE_LIBRARIES "algorithm;")
CPMAddPackage(
  NAME Boost
  VERSION 1.77.0
  GITHUB_REPOSITORY "boostorg/boost"
  GIT_TAG "boost-1.77.0"
)

include_directories(${cpp_httplib_SOURCE_DIR})
include_directories(${abseil_cpp_SOURCE_DIR})
include_directories(${json_SOURCE_DIR}/include) # nlohmann_json_SOURCE_DIR

find_package(folly CONFIG REQUIRED)

add_executable(main main.cc)

target_link_libraries(main PRIVATE fmt Boost::algorithm)
# target_include_directories(main PUBLIC
#   $<BUILD_INTERFACE:${Boost_INCLUDE_DIR}>
# )
