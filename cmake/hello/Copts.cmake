set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE "Release")

list(
  APPEND
  BASE_COPTS
  "-g"
  "-ggdb"
  "-O0"
  "-fno-omit-frame-pointer"
  "-gno-statement-frontiers"
  "-gno-variable-location-views"
  "-DBUILD_WITH_CMAKE"
  "-Wall")

list(APPEND DEFAULT_C_COPTS ${BASE_COPTS} "-std=gnu11" "-D_GNU_SOURCE"
     "-Wno-implicit-function-declaration")

list(APPEND DEFAULT_CPP_COPTS ${BASE_COPTS} "-std=c++20")

list(APPEND TEST_CPP_COPTS ${DEFAULT_CPP_COPTS} "-fsanitize=address")

list(APPEND DEFAULT_LINKOPTS "-latomic" "-lpthread" "-lrt" "-ldl" # "-fuse-ld=lld"
)

list(APPEND TEST_LINKOPTS ${DEFAULT_LINKOPTS} "-fsanitize=address")

# https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_FLAGS.html#variable:CMAKE_%3CLANG%3E_FLAGS
string(REPLACE ";" " " CMAKE_C_FLAGS "${DEFAULT_C_COPTS}")
string(REPLACE ";" " " CMAKE_CXX_FLAGS "${DEFAULT_CPP_COPTS}")
string(REPLACE ";" " " CMAKE_EXE_LINKER_FLAGS "${DEFAULT_LINKOPTS}")
string(REPLACE ";" " " CMAKE_SHARED_LINKER_FLAGS "${DEFAULT_LINKOPTS}")

# "-Wcast-qual"
# "-Wconversion-null"
# "-Wextra"
# "-Wmissing-declarations"
# "-Wmissing-field-initializers"
# "-Wno-conversion-null"
# "-Wno-deprecated-declarations"
# "-Wno-missing-declarations"
# "-Wno-sign-compare"
# "-Wno-unknown-pragmas"
# "-Wno-unused-function"
# "-Wno-unused-parameter"
# "-Wno-unused-private-field"
# "-Woverlength-strings"
# "-Wpointer-arith"
# "-Wunused-local-typedefs"
# "-Wunused-result"
# "-Wvarargs"
# "-Wvla"
# "-Wwrite-strings"
# "-DCATCH_CONFIG_ENABLE_ALL_STRINGMAKERS"

#   # Just work with clang. For unknown warning group '-Wunused-but-set-variable', ignored [-Wunknown-warning-option]
#   # "-Wno-unknown-warning-option"
#   # temporary flags for gcc10.1
#   "-Wno-deprecated-declarations"
