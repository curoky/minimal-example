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
class Flamegraph < Formula
  desc 'Stack trace visualizer'
  homepage 'https://github.com/brendangregg/FlameGraph'
  url 'https://github.com/brendangregg/FlameGraph/archive/master.zip'
  license 'CDDL-1.0'
  head 'https://github.com/brendangregg/FlameGraph.git'
  version '2.0'

  uses_from_macos 'perl'

  def install
    bin.install Dir['*.pl']
    bin.install Dir['*.awk']
  end

  test do
  end
end
