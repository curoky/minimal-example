CPMAddPackage(
  NAME abseil_cpp
  GITHUB_REPOSITORY abseil/abseil-cpp
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME benchmark
  GITHUB_REPOSITORY google/benchmark
  GIT_TAG main
  OPTIONS "CMAKE_BUILD_TYPE Debug" "BENCHMARK_ENABLE_TESTING OFF")
CPMAddPackage(
  NAME catch2
  GITHUB_REPOSITORY catchorg/Catch2
  GIT_TAG devel
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME cjson
  GITHUB_REPOSITORY DaveGamble/cJSON
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "ENABLE_CJSON_TEST OFF"
          "ENABLE_CJSON_UNINSTALL OFF")
CPMAddPackage(
  NAME concurrentqueue
  GITHUB_REPOSITORY cameron314/concurrentqueue
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME cpp_httplib
  GITHUB_REPOSITORY yhirose/cpp-httplib
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME cpp_peglib
  GITHUB_REPOSITORY yhirose/cpp-peglib
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME cppfs
  GITHUB_REPOSITORY cginternals/cppfs
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "OPTION_BUILD_TESTS OFF")
CPMAddPackage(
  NAME cppitertools
  GITHUB_REPOSITORY ryanhaining/cppitertools
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME cpr
  GITHUB_REPOSITORY libcpr/cpr
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "CURL_FOUND ON"
          "CPR_FORCE_USE_SYSTEM_CURL ON")
CPMAddPackage(
  NAME CURL
  GITHUB_REPOSITORY curl/curl
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug"
          "ENABLE_DEBUG ON"
          "ENABLE_CURLDEBUG ON"
          "BUILD_TESTING OFF"
          "BUILD_CURL_EXE OFF"
          "ENABLE_MANUAL OFF"
          "HAVE_GETNAMEINFO OFF")
CPMAddPackage(
  NAME json
  GITHUB_REPOSITORY nlohmann/json
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME jsoncpp
  GITHUB_REPOSITORY open-source-parsers/jsoncpp
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "JSONCPP_WITH_TESTS OFF"
          "JSONCPP_WITH_POST_BUILD_UNITTEST OFF")
CPMAddPackage(
  NAME msgpack_c
  GITHUB_REPOSITORY msgpack/msgpack-c
  GIT_TAG cpp_master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME nameof
  GITHUB_REPOSITORY Neargye/nameof
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME OpenSSL
  GITHUB_REPOSITORY openssl/openssl
  GIT_TAG OpenSSL_1_1_1g
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME parallel_hashmap
  GITHUB_REPOSITORY greg7mdp/parallel-hashmap
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME protobuf
  GITHUB_REPOSITORY protocolbuffers/protobuf
  GIT_TAG main
  OPTIONS "CMAKE_BUILD_TYPE Debug" "protobuf_MSVC_STATIC_RUNTIME OFF"
          "protobuf_BUILD_TESTS OFF" "protobuf_WITH_ZLIB ON")
CPMAddPackage(
  NAME rapidjson
  GITHUB_REPOSITORY Tencent/rapidjson
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "RAPIDJSON_BUILD_DOC OFF"
          "RAPIDJSON_BUILD_EXAMPLES OFF" "RAPIDJSON_BUILD_TESTS OFF")
CPMAddPackage(
  NAME restclient_cpp
  GITHUB_REPOSITORY mrtazz/restclient-cpp
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME rttr
  GITHUB_REPOSITORY rttrorg/rttr
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug"
          "BUILD_UNIT_TESTS OFF"
          "BUILD_EXAMPLES OFF"
          "BUILD_DOCUMENTATION OFF"
          "CUSTOM_DOXYGEN_STYLE OFF"
          "BUILD_INSTALLER OFF"
          "BUILD_PACKAGE OFF")
CPMAddPackage(
  NAME snappy
  GITHUB_REPOSITORY google/snappy
  GIT_TAG main
  OPTIONS "CMAKE_BUILD_TYPE Debug" "SNAPPY_BUILD_TESTS OFF"
          "SNAPPY_BUILD_BENCHMARKS OFF")
CPMAddPackage(
  NAME spdlog
  GITHUB_REPOSITORY gabime/spdlog
  GIT_TAG v1.10.0
  OPTIONS "CMAKE_BUILD_TYPE Debug" "SPDLOG_FMT_EXTERNAL=ON")
CPMAddPackage(
  NAME taskflow
  GITHUB_REPOSITORY taskflow/taskflow
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "TF_BUILD_TESTS OFF" "TF_BUILD_EXAMPLES OFF")
CPMAddPackage(
  NAME tbb
  GITHUB_REPOSITORY oneapi-src/oneTBB
  GIT_TAG master
  OPTIONS "CMAKE_BUILD_TYPE Debug" "SNAPPY_BUILD_TESTS OFF")
CPMAddPackage(
  NAME wangle
  GITHUB_REPOSITORY facebook/wangle
  GIT_TAG v2022.03.21.00
  OPTIONS "CMAKE_BUILD_TYPE Debug")
CPMAddPackage(
  NAME zstd
  GITHUB_REPOSITORY facebook/zstd
  GIT_TAG v1.5.0
  OPTIONS "CMAKE_BUILD_TYPE Debug" "BUILD_TESTING OFF")
