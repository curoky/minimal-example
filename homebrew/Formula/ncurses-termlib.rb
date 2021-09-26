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
class NcursesTermlib < Formula
  desc 'Text-based UI library'
  homepage 'https://www.gnu.org/software/ncurses/'
  url 'https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz'
  mirror 'https://ftpmirror.gnu.org/ncurses/ncurses-6.2.tar.gz'
  sha256 '30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d'
  license 'MIT'

  livecheck do
    url :stable
  end

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'ncurses'
  depends_on 'pkg-config' => :build
  depends_on 'gpatch' => :build unless OS.mac?
  depends_on 'gcc@11' => :build
  depends_on 'xz'

  def install
    if OS.linux?
      system './configure', "--prefix=#{prefix}",
             '--enable-pc-files',
             "--with-pkg-config-libdir=#{lib}/pkgconfig",
             '--enable-sigwinch',
             '--enable-symlinks',
             '--enable-widec',
             '--with-shared',
             '--without-termlib',
             '--with-termlib=tinfo',
             '--disable-termcap',
             '--disable-relink',
             '--disable-wattr-macros',
             '--with-gpm',
             '--with-progs',
             '--with-versioned-syms',
             '--disable-rpath',
             '--disable-stripping',
             '--enable-const',
             '--enable-echo',
             '--enable-overwrite',
             '--with-manpage-format=normal',
             '--with-ticlib=tic',
             '--with-xterm-kbs=del',
             '--without-ada',
             '--without-profile',
             '--without-progs',
             '--without-tests',
             "--with-terminfo-dirs=#{share}/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo"
    end

    system 'make', 'install'

    prefix.install 'test'
    (prefix / 'test').install 'install-sh', 'config.sub', 'config.guess'
  end

  test do
    ENV['TERM'] = 'xterm'

    system prefix / 'test/configure', "--prefix=#{testpath}/test",
           "--with-curses-dir=#{prefix}"
    system 'make', 'install'

    # FIXME(@curoky): make test good
    # system testpath/"test/bin/keynames"
    # system testpath/"test/bin/test_arrays"
    # system testpath/"test/bin/test_vidputs"
  end
end
