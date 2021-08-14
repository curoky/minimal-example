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

# https://github.com/Homebrew/linuxbrew-core/commits/a88912aba61c4f19f60466428789b01ef6854797/Formula/boost-python.rb
# https://github.com/Homebrew/linuxbrew-core/blob/97f17662893e8850044f6ac33f4a41686ee39da0/Formula/boost-python.rb

require_relative '../lib/boost_helper'

class BoostPythonAT1720 < Formula
  desc 'C++ library for C++/Python2 interoperability'
  homepage 'https://www.boost.org'
  helper = @helper = @@helper = BoostHelper.new('1.72.0') # rubocop:disable Style/ClassVars
  version helper.version
  url helper.url

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'python@2'
  depends_on "boost@#{helper.version}"

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << 'cxxflags=-std=c++14'
    args << 'cxxflags=-stdlib=libc++' << 'linkflags=-stdlib=libc++' if ENV.compiler == :clang

    # pyver = Language::Python.major_minor_version "python"
    pyver = '2.7'

    system './bootstrap.sh', "--prefix=#{prefix}", "--libdir=#{lib}",
           '--with-libraries=python', '--with-python=python2'

    system './b2', '--build-dir=build-python',
           '--stagedir=stage-python',
           '--libdir=install-python/lib',
           '--prefix=install-python',
           "python=#{pyver}",
           *args

    lib.install Dir['install-python/lib/*.*']
    lib.install Dir['stage-python/lib/*py*']
    doc.install Dir['libs/python/doc/*']
  end

  def caveats
    <<~EOS
      This formula provides Boost.Python for Python 2. Due to a
      collision with boost-python3, the CMake Config files are not
      available. Please use -DBoost_NO_BOOST_CMAKE=ON when building
      with CMake or switch to Python 3.
    EOS
  end

  test do
    (testpath / 'hello.cpp').write <<~EOS
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS
    python_config = Formula['python@2'].bin / 'python-config'
    pyprefix = `#{python_config} --prefix`.chomp
    pyincludes = Utils.popen_read("#{python_config} --includes").chomp.split(' ')
    pylib = Utils.popen_read("#{python_config} --ldflags").chomp.split(' ')

    system ENV.cxx, '-shared', 'hello.cpp',
           "-Wl,-rpath=#{lib}", "-L#{lib}", '-lboost_python27',
           '-o', 'hello.so', "-I#{pyprefix}/include/python2.7",
           "-I#{Formula['boost@1.72.0'].include}", '-fPIC',
           *pyincludes, "-L#{pyprefix}/lib", *pylib

    output = <<~EOS
      from __future__ import print_function
      import hello
      print(hello.greet())
    EOS
    assert_match 'Hello, world!', pipe_output("#{Formula['python@2'].bin}/python", output, 0)
  end
end
