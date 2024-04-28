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

# REF: https://github.com/igor-sadchenko/conan-restclient-cpp/

from conans import CMake, ConanFile, tools


class RestClientCppConan(ConanFile):
    name = "restclient-cpp"
    version = "0.5.2"
    scm = {
        "type": "git",
        "subfolder": "source_subfolder",
        "url": "https://github.com/mrtazz/restclient-cpp.git",
        "revision": version
    }
    exports_sources = ["CMakeLists.txt"]

    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = (
        "shared=False",
        "fPIC=True",
    )

    generators = "cmake"
    _cmake = None

    def _configure_cmake(self):
        if self._cmake:
            return self._cmake

        self._cmake = CMake(self, set_cmake_flags=True)
        self._cmake.definitions["BUILD_SHARED_LIBS"] = self.options.shared
        self._cmake.configure()
        return self._cmake

    def build(self):
        cmake = self._configure_cmake()
        cmake.build()

    def package(self):
        cmake = self._configure_cmake()
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)

    def requirements(self):
        self.requires.add("libcurl/7.80.0")
        self.requires.add("openssl/1.1.1n")
