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
class GitMvWithHistory < Formula
  desc 'git utility to move/rename file or folder and retain history with it.'
  homepage 'https://gist.github.com/emiller/6769886'
  url 'https://gist.github.com/emiller/6769886/archive/ae47266e867438b9cbd188fb6851ca6566e241d0.zip'
  sha256 '0be3fc72b064e199b031e01a3e3725b093ccb234f8ad58e001d8e5c854a9299c'
  version 'head'

  def install
    bin.install 'git-mv-with-history' => 'git-mv-with-history'
  end

  test do
    ohai 'Test complete.'
  end
end
