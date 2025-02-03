#
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of minimal-example.
# See https://github.com/curoky/minimal-example for further info.
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
class GflagsAT222 < Formula
  desc 'Library for processing command-line flags'
  homepage 'https://gflags.github.io/gflags/'
  url 'https://github.com/gflags/gflags/archive/v2.2.2.tar.gz'
  license 'BSD-3-Clause'

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'gcc@11' => %i[build test]

  def install
    gcc = Formula['gcc@11']
    mkdir 'buildroot' do
      args = std_cmake_args + %W[
        -GNinja
        --log-level=STATUS
        -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
        -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
        -DBUILD_SHARED_LIBS=ON
      ]

      system 'cmake', '..', *args
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
    (testpath / 'test.cpp').write <<~EOS
      #include <iostream>
      #include "gflags/gflags.h"

      DEFINE_bool(verbose, false, "Display program name before message");
      DEFINE_string(message, "Hello world!", "Message to print");

      static bool IsNonEmptyMessage(const char *flagname, const std::string &value)
      {
        return value[0] != '\0';
      }
      DEFINE_validator(message, &IsNonEmptyMessage);

      int main(int argc, char *argv[])
      {
        gflags::SetUsageMessage("some usage message");
        gflags::SetVersionString("1.0.0");
        gflags::ParseCommandLineFlags(&argc, &argv, true);
        if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
        std::cout << FLAGS_message;
        gflags::ShutDownCommandLineFlags();
        return 0;
      }
    EOS
    system Formula['gcc@11'].bin / 'c++-11',
           "-Wl,-rpath=#{lib}", "-L#{lib}", '-lgflags', 'test.cpp', '-o', 'test'
    assert_match 'Hello world!', shell_output('./test')
    assert_match 'Foo bar!', shell_output("./test --message='Foo bar!'")
  end
end
