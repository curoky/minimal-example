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
class VimBundle < Formula
  desc 'Bundle vim plugins'
  homepage 'https://github.com/junegunn/vim-plug'
  url 'https://github.com/junegunn/vim-plug/archive/master.zip'
  head 'https://github.com/junegunn/vim-plug.git'
  version 'head'

  resource 'delimitMate' do
    url 'https://github.com/Raimondi/delimitMate/archive/master.zip'
  end
  resource 'vim-airline' do
    url 'https://github.com/vim-airline/vim-airline/archive/master.zip'
  end
  resource 'vim-airline-themes' do
    url 'https://github.com/vim-airline/vim-airline-themes/archive/master.zip'
  end
  resource 'vim-colors-solarized' do
    url 'https://github.com/altercation/vim-colors-solarized/archive/master.zip'
  end
  resource 'indentLine' do
    url 'https://github.com/Yggdroot/indentLine/archive/master.zip'
  end
  resource 'vim-commentary' do
    url 'https://github.com/tpope/vim-commentary/archive/master.zip'
  end
  resource 'vim-fugitive' do
    url 'https://github.com/tpope/vim-fugitive/archive/master.zip'
  end
  resource 'vim-gitgutter' do
    url 'https://github.com/airblade/vim-gitgutter/archive/master.zip'
  end
  resource 'nerdtree' do
    url 'https://github.com/preservim/nerdtree/archive/master.zip'
  end
  resource 'nerdtree-git-plugin' do
    url 'https://github.com/Xuyuanp/nerdtree-git-plugin/archive/master.zip'
  end

  keg_only :versioned_formula

  def install
    prefix.install Dir['*']
    (prefix / 'vim-plugin/plugged/delimitMate').install resource('delimitMate')
    (prefix / 'vim-plugin/plugged/vim-airline').install resource('vim-airline')
    (prefix / 'vim-plugin/plugged/vim-airline-themes').install resource('vim-airline-themes')
    (prefix / 'vim-plugin/plugged/vim-colors-solarized').install resource('vim-colors-solarized')
    (prefix / 'vim-plugin/plugged/indentLine').install resource('indentLine')
    (prefix / 'vim-plugin/plugged/vim-commentary').install resource('vim-commentary')
    (prefix / 'vim-plugin/plugged/vim-fugitive').install resource('vim-fugitive')
    (prefix / 'vim-plugin/plugged/vim-gitgutter').install resource('vim-gitgutter')
    (prefix / 'vim-plugin/plugged/nerdtree').install resource('nerdtree')
    (prefix / 'vim-plugin/plugged/nerdtree-git-plugin').install resource('nerdtree-git-plugin')

    mkdir_p "#{prefix}/vim-plugin/autoload"
    ln_sf "#{prefix}/plug.vim", "#{prefix}/vim-plugin/autoload/plug.vim"
  end

  test do
    ohai 'Test complete.'
  end
end
