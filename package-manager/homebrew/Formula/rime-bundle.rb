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
class RimeBundle < Formula
  include Language::Python::Virtualenv

  desc 'Bundle rime dict'
  homepage 'https://rime.im'
  url 'https://github.com/rime/squirrel/archive/refs/tags/0.15.2.tar.gz'
  # version '1.0.0'

  resource 'rime-emoji' do
    url 'https://github.com/rime/rime-emoji/archive/master.tar.gz'
  end

  resource 'meow-emoji-rime' do
    url 'https://github.com/hitigon/meow-emoji-rime/archive/master.tar.gz'
  end

  resource 'rime-prelude' do
    url 'https://github.com/rime/rime-prelude/archive/master.tar.gz'
  end

  resource 'rime-symbols' do
    url 'https://github.com/fkxxyz/rime-symbols/archive/master.tar.gz'
  end

  resource 'rime-dict' do
    url 'https://github.com/Iorest/rime-dict/archive/master.tar.gz'
  end

  resource 'rime-cloverpinyin' do
    url 'https://github.com/fkxxyz/rime-cloverpinyin/releases/download/1.1.4/clover.schema-1.1.4.zip'
  end

  resource 'rime-ice' do
    url 'https://github.com/iDvel/rime-ice/archive/main.tar.gz'
  end

  keg_only :versioned_formula

  depends_on 'python@3' => :build
  depends_on 'opencc' => :build

  def install
    venv = virtualenv_create(libexec, 'python3')
    venv.pip_install 'opencc'

    # emoji and symbols
    resource('rime-emoji').stage do
      Pathname.glob('opencc/*.txt') do |file|
        system 'opencc', '-i', file, '-o', "opencc/simple.#{file.basename}", '-c', 't2s.json'
      end
      (prefix / 'opencc/rime-emoji').install Dir['opencc/*']
    end

    resource('rime-symbols').stage do
      system libexec / 'bin/python3', './rime-symbols-gen'
      Pathname.glob('*.txt') do |file|
        system 'opencc', '-i', file, '-o', "simple.#{file.basename}", '-c', 't2s.json'
      end
      (prefix / 'opencc/rime-symbols').install Dir['*']
    end

    resource('rime-ice').stage do
      (prefix / 'opencc/rime-ice').install Dir['opencc/*']
    end

    # dict
    resource('rime-dict').stage do
      Pathname.glob('**/*.dict.yaml') do |file|
        system 'opencc', '-i', file, '-o', "simple.#{file.basename}", '-c', 't2s.json'
      end
      (prefix / 'dicts/rime-dict').install Dir['simple.*']
    end

    resource('rime-ice').stage do
      (prefix / 'dicts/rime-ice').install 'cn_dicts', 'en_dicts'
    end

    resource('rime-cloverpinyin').stage do
      (prefix / 'dicts/rime-cloverpinyin').install Dir['*.dict.yaml']
    end

    # setting
    resource('rime-cloverpinyin').stage do
      prefix.install Dir['clover.*.yaml']
    end
  end

  test do
    ohai 'Test complete.'
  end
end
