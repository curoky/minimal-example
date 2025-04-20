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
class ZshBundle < Formula
  desc 'Bundle zsh plugins'
  homepage 'https://github.com/ohmyzsh/ohmyzsh'
  url 'https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.tar.gz'
  head 'https://github.com/ohmyzsh/ohmyzsh.git'
  version 'head'

  resource 'zsh-autosuggestions' do
    url 'https://github.com/zsh-users/zsh-autosuggestions/archive/refs/heads/master.tar.gz'
  end
  resource 'zsh-completions' do
    url 'https://github.com/zsh-users/zsh-completions/archive/refs/heads/master.tar.gz'
  end
  resource 'zsh-syntax-highlighting' do
    url 'https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/heads/master.tar.gz'
  end
  resource 'spaceship-prompt' do
    url 'https://github.com/denysdovhan/spaceship-prompt/archive/refs/heads/master.tar.gz'
  end
  resource 'conda-zsh-completion' do
    url 'https://github.com/esc/conda-zsh-completion/archive/refs/heads/master.tar.gz'
  end

  keg_only :versioned_formula

  def install
    prefix.install Dir['*']
    (prefix / 'custom/plugins/zsh-autosuggestions').install resource('zsh-autosuggestions')
    (prefix / 'custom/plugins/zsh-completions').install resource('zsh-completions')
    (prefix / 'custom/plugins/zsh-syntax-highlighting').install resource('zsh-syntax-highlighting')

    # (prefix / 'custom/themes/spaceship-prompt').install resource('spaceship-prompt')
    (prefix / 'custom/plugins/conda-zsh-completion').install resource('conda-zsh-completion')
  end

  test do
    ohai 'Test complete.'
  end
end
