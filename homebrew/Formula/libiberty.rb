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
require 'os/linux/glibc'

class Libiberty < Formula
  desc 'The libiberty library is a collection of subroutines used by various GNU programs.'
  homepage 'https://gcc.gnu.org/onlinedocs/libiberty'
  url 'https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.2.1.tar.xz'
  mirror 'https://ftpmirror.gnu.org/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz'
  license 'GPL-3.0'

  keg_only :versioned_formula

  depends_on 'gcc@11'

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'

    args = %W[
      --prefix=#{prefix}
      --enable-install-libiberty
    ]

    mkdir 'build' do
      ENV.append_to_cflags '-fPIC'
      system '../libiberty/configure', *args
      system 'make'
      system 'make', 'install'
    end
  end

  test do
    ohai 'Test complete.'
  end
end
