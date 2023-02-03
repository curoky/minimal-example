# Copyright (c) 2018-2023 curoky(cccuroky@gmail.com).
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

# REF: https://github.com/TUM-CONAN/conan-cppfs/

from conans import CMake, ConanFile, tools


class CppfsConan(ConanFile):
    name = 'cppfs'
    version = '1.3.0'
    scm = {
        'type': 'git',
        'url': 'https://github.com/cginternals/cppfs.git',
        'revision': 'v%s' % version
    }

    settings = 'os', 'compiler', 'build_type', 'arch'
    options = {
        'shared': [True, False],
    }
    default_options = ('shared=True',)

    generators = 'cmake'
    _cmake = None

    def _configure_cmake(self):
        if self._cmake:
            return self._cmake

        self._cmake = CMake(self, set_cmake_flags=True)
        self._cmake.definitions['BUILD_SHARED_LIBS'] = self.options.shared
        self._cmake.definitions['OPTION_BUILD_TESTS'] = False
        self._cmake.configure(build_folder='build_subfolder')
        return self._cmake

    def build(self):
        cmake = self._configure_cmake()
        cmake.build()

    def package(self):
        cmake = self._configure_cmake()
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
