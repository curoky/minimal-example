#
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of minimal-example.
# See https://github.com/curoky/minimal-example for further info.
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
class NcursesAT5 < Formula
  desc 'Text-based UI library'
  homepage 'https://www.gnu.org/software/ncurses/'
  url 'https://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz'
  mirror 'https://ftpmirror.gnu.org/ncurses/ncurses-5.9.tar.gz'
  sha256 '9046298fb440324c9d4135ecea7879ffed8546dd1b58e59430ea07a4633f563b'

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'pkg-config' => :build
  depends_on 'gcc@5' => :build

  def install
    # Fix the build for GCC 5.1
    # error: expected ')' before 'int' in definition of macro 'mouse_trafo'
    # See https://lists.gnu.org/archive/html/bug-ncurses/2014-07/msg00022.html
    # and https://trac.sagemath.org/ticket/18301
    # Disable linemarker output of cpp
    ENV.append 'CPPFLAGS', '-P'
    ENV['CC'] = Formula['gcc@5'].opt_bin / 'gcc-5'
    ENV['CXX'] = Formula['gcc@5'].opt_bin / 'g++-5'

    args = [
      "--prefix=#{prefix}",
      '--enable-pc-files',
      "--with-pkg-config-libdir=#{lib}/pkgconfig",
      '--enable-sigwinch',
      '--enable-symlinks',
      '--enable-widec',
      '--with-shared',
      '--with-gpm=no',
      '--without-ada'
    ]
    args << "--with-terminfo-dirs=#{share}/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo" if OS.linux?

    system './configure', *args
    system 'make', 'install'
    make_libncurses_symlinks

    # prefix.install "test"
    # (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.major

    %w[form menu ncurses panel].each do |name|
      on_macos do
        lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.dylib"
        lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.#{major}.dylib"
      end
      on_linux do
        lib.install_symlink "lib#{name}w.so.#{major}" => "lib#{name}.so"
        lib.install_symlink "lib#{name}w.so.#{major}" => "lib#{name}.so.#{major}"
      end
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink 'libncurses++w.a' => 'libncurses++.a'
    lib.install_symlink 'libncurses.a' => 'libcurses.a'
    lib.install_symlink shared_library('libncurses') => shared_library('libcurses')
    on_linux do
      lib.install_symlink 'libncurses.so' => 'libtermcap.so'
      lib.install_symlink 'libncurses.so' => 'libtinfo.so'
      # For binary compatibility
      lib.install_symlink 'libncurses.so.5' => 'libtinfo.so.5'
    end

    (lib / 'pkgconfig').install_symlink 'ncursesw.pc' => 'ncurses.pc'

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink [
      'ncursesw/curses.h', 'ncursesw/form.h', 'ncursesw/ncurses.h',
      'ncursesw/panel.h', 'ncursesw/term.h', 'ncursesw/termcap.h'
    ]
  end

  test do
    # FIXME(@curoky): make test good
    # ENV["TERM"] = "xterm"
    # system bin/"tput", "cols"

    # system prefix/"test/configure", "--prefix=#{testpath}/test",
    #                                 "--with-curses-dir=#{prefix}"
    # system "make", "install"

    # system testpath/"test/bin/keynames"
    # system testpath/"test/bin/test_arrays"
  end
end
