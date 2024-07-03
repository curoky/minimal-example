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
class BoostHelper
  attr_reader :url, :version

  def initialize(version)
    @version = version
    if Gem::Version.new(version) < Gem::Version.new('1.63.0')
      @url = "https://downloads.sourceforge.net/project/boost/boost/#{version}/boost_#{version.gsub('.', '_')}.tar.bz2"
    else
      @url = "https://boostorg.jfrog.io/artifactory/main/release/#{version}/source/boost_#{version.gsub('.',
                                                                                                        '_')}.tar.bz2"
    end
  end

  def caveats(lib)
    s = ''
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
      s += <<~EOS
        Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    s
  end

  def install(prefix, lib)
    # Force boost to compile with the desired compiler
    # https://stackoverflow.com/questions/5346454/building-boost-with-different-gcc-version
    open('user-config.jam', 'a') do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{Formula['gcc@11'].opt_bin}/g++-11 ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula['icu4c'].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
    ]
    bootstrap_args << if OS.mac?
                        "--with-icu=#{icu4c_prefix}"
                      else
                        '--without-icu'
                      end

    # Handle libraries that will not be built.
    without_libraries = %w[python mpi]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << 'log' if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(',')}"

    # layout should be synchronized with boost-python and boost-mpi
    # TODO: does we need threading=single,multi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged
      --user-config=user-config.jam
      install
      link=shared
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << 'cxxflags=-std=c++14'
    args << 'cxxflags=-stdlib=libc++' << 'linkflags=-stdlib=libc++' if ENV.compiler == :clang

    # Fix error: bzlib.h: No such file or directory
    # and /usr/bin/ld: cannot find -lbz2
    args += ["include=#{HOMEBREW_PREFIX}/include", "linkflags=-L#{HOMEBREW_PREFIX}/lib"] unless OS.mac?
    puts bootstrap_args
    [bootstrap_args, args]
  end

  def test(testpath, include, lib)
    (testpath / 'test.cpp').write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;
      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    if OS.mac?
      system Formula['gcc@11'].opt_bin / 'g++-11', 'test.cpp', '-std=c++14', '-stdlib=libc++', '-o', 'test'
    else
      system Formula['gcc@11'].opt_bin / 'g++-11', "-I#{include}", 'test.cpp', '-std=c++1y',
             "-Wl,-rpath=#{lib}", "-L#{lib}", '-lboost_system-mt', '-o', 'test'
    end
    system './test'
  end
end
