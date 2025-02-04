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

#include <format>
#include <iostream>

int main(int argc, char const *argv[]) {
  std::cout << std::format(
      "__clang__: {}\n"
      "__clang_major__: {}\n"
      "__clang_minor__: {}\n"
      "__clang_patchlevel__: {}\n"
      "__clang_version__: {}\n",
      __clang__,             // set to 1 if compiler is clang
      __clang_major__,       // integer: major marketing version number of clang
      __clang_minor__,       // integer: minor marketing version number of clang
      __clang_patchlevel__,  // integer: marketing patch level of clang
      __clang_version__      // string: full version number
  );
  return 0;
}
