#
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of dotbox.
# See https://github.com/curoky/dotbox for further info.
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
class ExaWrapper < Formula
  desc 'Wrapper script for exa to give it nearly identical switches and appearance to ls.'
  homepage 'https://gist.github.com/curoky/47dcc36c748c668c4252752ab2ae95a7'
  url 'https://gist.github.com/curoky/47dcc36c748c668c4252752ab2ae95a7/archive/master.tar.gz'
  version 'head'

  def install
    bin.install 'exa-wrapper.sh' => 'ls'
  end

  test do
    ohai 'Test complete.'
  end
end
