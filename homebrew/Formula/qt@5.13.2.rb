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
class QtAT5132 < Formula
  desc 'Cross-platform application and UI framework'
  homepage 'https://www.qt.io/'
  url 'https://download.qt.io/official_releases/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz'
  mirror 'http://qt.mirror.constant.com/archive/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz'
  mirror 'http://qt.mirrors.tds.net/qt/archive/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz'
  mirror 'https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz'
  sha256 '55e8273536be41f4f63064a79e552a22133848bb419400b6fa8e9fc0dc05de08'

  keg_only :versioned_formula
  # keg_only "Qt 5 has CMake issues when linked"

  depends_on :linux
  depends_on 'pkg-config' => :build
  depends_on 'gcc@11' => :build

  unless OS.mac?
    depends_on 'fontconfig'
    depends_on 'glib'
    depends_on 'icu4c'
    depends_on 'libproxy'
    depends_on 'pulseaudio'
    depends_on 'python@2'
    depends_on 'sqlite'
    depends_on 'systemd'
    depends_on 'libxkbcommon'
    depends_on 'mesa' # "linuxbrew/xorg/mesa"
    depends_on 'xcb-util-image' # "linuxbrew/xorg/xcb-util-image"
    depends_on 'xcb-util-keysyms' # "linuxbrew/xorg/xcb-util-keysyms"
    depends_on 'xcb-util-renderutil' # "linuxbrew/xorg/xcb-util-renderutil"
    depends_on 'xcb-util' # "linuxbrew/xorg/xcb-util"
    depends_on 'xcb-util-wm' # "linuxbrew/xorg/xcb-util-wm"
    # depends_on "linuxbrew/xorg/xorg"
  end

  def install
    gcc = Formula['gcc@11']
    gcc_major_ver = gcc.any_installed_version.major
    ENV['CC'] = gcc.opt_bin / "gcc-#{gcc_major_ver}"
    ENV['CXX'] = gcc.opt_bin / "g++-#{gcc_major_ver}"

    # inreplace "qtbase/mkspecs/common/g++-base.conf", "gcc"
    #   "#{Formula["gcc"].opt_bin}/\"gcc-11\""
    # inreplace "qtbase/mkspecs/common/g++-base.conf", "g++"
    #   "#{Formula["gcc"].opt_bin}/\"g++-11\""

    args = %W[
      -verbose
      -prefix #{prefix}
      -opensource -confirm-license
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
    ]
    # -kip (cat .gitmodules | grep "submodule" | grep -o "qt\w*" | xargs -n 1 echo '  -skip')
    args_skip_modules = %w[
      -skip qtsvg
      -skip qtdeclarative
      -skip qtactiveqt
      -skip qtscript
      -skip qtmultimedia
      -skip qttools
      -skip qtxmlpatterns
      -skip qttranslations
      -skip qtdoc
      -skip qtrepotools
      -skip qtqa
      -skip qtlocation
      -skip qtsensors
      -skip qtsystems
      -skip qtfeedback
      -skip qtdocgallery
      -skip qtpim
      -skip qtconnectivity
      -skip qtwayland
      -skip qt3d
      -skip qtimageformats
      -skip qtgraphicaleffects
      -skip qtquickcontrols
      -skip qtserialbus
      -skip qtserialport
      -skip qtx11extras
      -skip qtmacextras
      -skip qtwinextras
      -skip qtandroidextras
      -skip qtwebsockets
      -skip qtwebchannel
      -skip qtwebengine
      -skip qtcanvas3d
      -skip qtwebview
      -skip qtquickcontrols2
      -skip qtpurchasing
      -skip qtcharts
      -skip qtdatavis3d
      -skip qtvirtualkeyboard
      -skip qtgamepad
      -skip qtscxml
      -skip qtspeech
      -skip qtnetworkauth
      -skip qtremoteobjects
      -skip qtwebglplugin
      -skip qtlottie
    ]

    if OS.mac?
      args << '-no-rpath'
      args << '-system-zlib'
    elsif OS.linux?
      args << '-system-xcb'
      args << "-R#{lib}"
      # https://bugreports.qt.io/projects/QTBUG/issues/QTBUG-71564
      args << '-no-avx2'
      args << '-no-avx512'
      args << '-qt-zlib'
    end

    system './configure', *args, *args_skip_modules
    system 'make'
    ENV.deparallelize
    system 'make', 'install'

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename('.framework')
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats
    <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath / 'hello.pro').write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath / 'main.cpp').write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin / 'qmake', testpath / 'hello.pro'
    system 'make'
    assert_predicate testpath / 'hello', :exist?
    assert_predicate testpath / 'main.o', :exist?
    system './hello'
  end
end
