class Fbthriftc < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server."
  homepage 'https://github.com/facebook/fbthrift'
  version ENV['HOMEBREW_FBTHRIFTC_VERSION'] || '2022.04.25.00'
  url "https://github.com/facebook/fbthrift/archive/v#{version}.tar.gz"

  depends_on 'flex' => :build
  depends_on 'bison' => :build
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'mstch' => :build
  depends_on 'python@3' => :build
  depends_on 'boost' => :build
  depends_on 'openssl@1.1' => :build
  depends_on 'libevent' => :build
  depends_on 'fmt-static' => :build

  def install
    boost = Formula['boost']
    ENV.append 'CXXFLAGS', "-I#{Formula['boost'].opt_include}"

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -Dcompiler_only=ON
      -Dthriftpy3=OFF
      -Denable_tests=OFF
      -DOPENSSL_USE_STATIC_LIBS=ON
      -DBoost_USE_STATIC_LIBS=ON
      -DBoost_INCLUDE_DIRS=#{boost.include}
      -DBoost_LIBRARIES="boost_filesystem"
      -DCMAKE_PREFIX_PATH='#{Formula['libevent'].prefix};#{Formula['openssl@1.1'].prefix}'
    ]
    args << "-DCMAKE_CXX_FLAGS_MINSIZEREL='-Os -DNDEBUG -s'"
    args << "-DCMAKE_EXE_LINKER_FLAGS='-static'" if OS.linux?
    # NOTE: we can use gcc10 on macox
    # args << "-DCMAKE_EXE_LINKER_FLAGS='-static-libgcc -static-libstdc++'" if OS.mac?

    inreplace 'CMakeLists.txt', 'set(CMAKE_INSTALL_RPATH', '#set(CMAKE_INSTALL_RPATH'
    inreplace 'CMakeLists.txt', 'if (compiler_only OR build_all)',
              "if (compiler_only OR build_all) \n find_package(fmt CONFIG REQUIRED)"

    mkdir 'build' do
      system 'cmake', *args, '..'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
    if OS.linux?
      output = shell_output("ldd #{bin}/thrift1 2>&1", 1).strip
      assert_equal 'not a dynamic executable', output
    elsif OS.mac?
      # TODO(@curoky): use `otool -L` to check.
    end
    # TODO(@curoky): check some message
    # shell_output("#{bin}/thrift1 --version", 1)
  end
end
