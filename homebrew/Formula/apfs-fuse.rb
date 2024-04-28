#
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
#
class ApfsFuse < Formula
  desc 'FUSE driver for APFS (Apple File System)'
  homepage 'https://github.com/sgan81/apfs-fuse'
  url 'https://github.com/sgan81/apfs-fuse/archive/master.zip'
  version 'head'

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'pkg-config' => :build
  depends_on 'zlib'
  depends_on 'libfuse'

  resource 'lzfse' do
    url 'https://github.com/lzfse/lzfse/archive/e634ca58b4821d9f3d560cdc6df5dec02ffc93fd.zip'
  end

  def install
    gcc = Formula['gcc@11']

    resource('lzfse').stage Pathname.pwd / '3rdparty/lzfse'

    inreplace 'CMakeLists.txt',
              'include_directories(. 3rdparty/lzfse/src)',
              "include_directories(. 3rdparty/lzfse/src #{Formula['zlib'].include})\n link_directories(#{Formula['zlib'].lib})" # rubocop:disable Layout/LineLength

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
      -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
    ]

    mkdir 'build' do
      system 'cmake', *args, '..'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
  end
end
