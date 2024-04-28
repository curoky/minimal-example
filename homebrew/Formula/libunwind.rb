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
class Libunwind < Formula
  desc 'C API for determining the call-chain of a program'
  homepage 'https://www.nongnu.org/libunwind/'
  url 'https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.5.0.tar.gz'
  sha256 '90337653d92d4a13de590781371c604f9031cdb50520366aa1e3a91e1efb1017'
  license 'MIT'

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'gcc@11' => :build

  uses_from_macos 'xz'
  uses_from_macos 'zlib'

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'
    ENV.append_to_cflags '-fPIC'

    system './configure', *std_configure_args, \
           '--disable-silent-rules', '--disable-minidebuginfo'
    system 'make'
    system 'make', 'install'
  end

  test do
    (testpath / 'test.c').write <<~EOS
      #include <libunwind.h>
      int main() {
        unw_context_t uc;
        unw_getcontext(&uc);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", 'test.c', "-Wl,-rpath=#{lib}", "-L#{lib}", '-lunwind', '-o', 'test'
    system './test'
  end
end
