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
require_relative '../lib/boost_helper'

class BoostAT1720 < Formula
  desc 'Collection of portable C++ source libraries'
  homepage 'https://www.boost.org'
  helper = @helper = @@helper = BoostHelper.new('1.72.0') # rubocop:disable Style/ClassVars
  version helper.version
  url helper.url

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'bzip2'
  depends_on 'zlib'

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
