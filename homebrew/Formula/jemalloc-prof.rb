#
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
#
class JemallocProf < Formula
  desc 'Implementation of malloc emphasizing fragmentation avoidance'
  homepage 'http://jemalloc.net/'
  # url "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2"
  url 'https://github.com/jemalloc/jemalloc/archive/refs/heads/dev.zip'
  license 'BSD-2-Clause'
  version 'head'

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'autoconf' => :build
  depends_on 'docbook-xsl' => :build
  depends_on 'curoky/tap/libunwind' => :build

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'
    ENV.prepend 'CFLAGS', "-I#{Formula['curoky/tap/libunwind'].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-jemalloc-prefix=
      --enable-prof
      --enable-prof-libunwind
    ]
    args << "--with-static-libunwind=#{Formula['curoky/tap/libunwind'].opt_lib}/libunwind.a"

    args << "--with-xslroot=#{Formula['docbook-xsl'].opt_prefix}/docbook-xsl"
    system './autogen.sh', *args
    system 'make', 'dist'

    system 'make'
    # system "make", "check"
    system 'make', 'install'
  end

  test do
    (testpath / 'test.c').write <<~EOS
      #include <stdlib.h>
      #include <jemalloc/jemalloc.h>
      int main(void) {
        for (size_t i = 0; i < 1000; i++) {
            // Leak some memory
            malloc(i * 100);
        }
        // Dump allocator statistics to stderr
        malloc_stats_print(NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, 'test.c', "-L#{lib}", '-ljemalloc', '-o', 'test'
    system './test'
  end
end
