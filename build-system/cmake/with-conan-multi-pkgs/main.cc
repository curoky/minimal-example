/*
 * Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
 *
 * This file is part of minimal-example.
 * See https://github.com/curoky/minimal-example for further info.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <absl/algorithm/algorithm.h>
#include <benchmark/benchmark.h>
#include <bitsery/bitsery.h>
#include <boost/algorithm/string.hpp>
#include <catch2/catch_version.hpp>
#include <cjson/cJSON.h>
#include <concurrentqueue.h>
#include <cppfs/cppfs.h>
#include <cppitertools/sorted.hpp>
#include <cpr/cpr.h>
#include <crc32c/crc32c.h>
#include <flatbuffers/flatbuffers.h>
#include <fmt/format.h>
#include <gflags/gflags.h>
#include <gtest/gtest.h>
#include <immer/algorithm.hpp>
#include <json/json.h>
#include <rapidjson/reader.h>
#include <snappy.h>
#include <taskflow/taskflow.hpp>
#include <tbb/tbb.h>
#include <thrift/server/TServer.h>
#include <uv.h>
#include <zstd.h>

#include <iostream>

int main(int argc, char const *argv[]) {
  std::vector<std::string> v;
  boost::split(v, "hello, world!", boost::is_any_of(" "));
  std::cout << boost::join(v, " ") << std::endl;

  fmt::print("Hello, {}!\n", "world");
  return 0;
}
