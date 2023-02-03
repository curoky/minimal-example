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
require_relative '../lib/boost_helper'

class BoostAT1600 < Formula
  desc 'Collection of portable C++ source libraries'
  homepage 'https://www.boost.org'
  helper = @helper = @@helper = BoostHelper.new('1.60.0') # rubocop:disable Style/ClassVars
  version helper.version
  url helper.url

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'bzip2'
  depends_on 'zlib'

  # Handle compile failure with boost/graph/adjacency_matrix.hpp
  # https://github.com/Homebrew/homebrew/pull/48262
  # https://svn.boost.org/trac/boost/ticket/11880
  # patch derived from https://github.com/boostorg/graph/commit/1d5f43d
  patch :DATA

  # Fix auto-pointer registration in 1.60
  # https://github.com/boostorg/python/pull/59
  # patch derived from https://github.com/boostorg/python/commit/f2c465f
  patch do
    url 'https://raw.githubusercontent.com/Homebrew/formula-patches/9e56b450f3f5fd8095540e43184b13ab2824f911/boost/boost1_60_0_python_class_metadata.diff'
    sha256 '1a470c3a2738af409f68e3301eaecd8d07f27a8965824baf8aee0adef463b844'
  end

  # Fix build on Xcode 11.4
  patch do
    url 'https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1'
    sha256 '04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08'
    directory 'tools/build'
  end

  def install
    args = @@helper.install(prefix, lib)
    system './bootstrap.sh', *args[0]
    system './b2', 'headers'
    system './b2', *args[1]
  end

  def caveats
    @@helper.caveats(lib)
  end

  test do
    helper.test(testpath, include, lib)
  end
end

__END__
diff -Nur boost_1_60_0/boost/graph/adjacency_matrix.hpp boost_1_60_0-patched/boost/graph/adjacency_matrix.hpp
--- boost_1_60_0/boost/graph/adjacency_matrix.hpp	2015-10-23 05:50:19.000000000 -0700
+++ boost_1_60_0-patched/boost/graph/adjacency_matrix.hpp	2016-01-19 14:03:29.000000000 -0800
@@ -443,7 +443,7 @@
     // graph type. Instead, use directedS, which also provides the
     // functionality required for a Bidirectional Graph (in_edges,
     // in_degree, etc.).
-    BOOST_STATIC_ASSERT(type_traits::ice_not<(is_same<Directed, bidirectionalS>::value)>::value);
+    BOOST_STATIC_ASSERT(!(is_same<Directed, bidirectionalS>::value));

     typedef typename mpl::if_<is_directed,
                                     bidirectional_tag, undirected_tag>::type
