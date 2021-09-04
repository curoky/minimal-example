#
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
#
class FbthriftAT20210215 < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server."
  homepage 'https://github.com/facebook/fbthrift'
  url 'https://github.com/facebook/fbthrift/archive/v2021.02.15.00.tar.gz'

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'flex' => :build
  depends_on 'bison' => :build
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'gcc@11' => :build

  depends_on 'python@3.9'
  depends_on 'libsodium'
  depends_on 'zlib'
  depends_on 'boost@1.72.0'
  depends_on 'libevent'
  depends_on 'openssl@1.1'
  depends_on 'folly@2021.02.15'
  depends_on 'fizz@2021.02.15'
  depends_on 'wangle@2021.02.15'

  def install
    gcc = Formula['gcc@11']
    boost = Formula['boost@1.72.0']

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
      -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
      -Dcompiler_only=OFF
      -Dthriftpy=OFF
      -Dthriftpy3=OFF
      -Denable_tests=OFF
      -Dpython-six_FOUND=ON
      -DOPENSSL_USE_STATIC_LIBS=ON
      -DBoost_USE_STATIC_LIBS=ON
      -DBoost_INCLUDE_DIRS=#{boost.include}
      -DBoost_LIBRARIES="boost_filesystem"
      -DCMAKE_PREFIX_PATH='#{Formula['libevent'].prefix};#{Formula['zlib'].prefix};#{boost.prefix}'
    ]

    # mkdir "build-d" do
    #   system "cmake", *args, "..", "-DBUILD_SHARED_LIBS=ON"
    #   system "ninja"
    #   system "ninja", "install"
    # end
    mkdir 'build-s' do
      system 'cmake', *args, '..', '-DBUILD_SHARED_LIBS=OFF'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
  end
end
