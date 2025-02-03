function(gen_thrift)
  cmake_parse_arguments(
    GEN_THRIFT # Prefix
    "" # Options
    "FILE_NAME;FILE_PATH;LANGUAGE;OUTPUT_PATH;INCLUDE_PREFIX;OPTIONS" # One Value args
    "SERVICES;INCLUDE_DIRECTORIES" # Multi-value args
    "${ARGN}")

  set(file_name ${GEN_THRIFT_FILE_NAME})
  set(file_path ${PROJECT_SOURCE_DIR}/${GEN_THRIFT_FILE_PATH})
  set(language ${GEN_THRIFT_LANGUAGE})
  set(output_path ${PROJECT_SOURCE_DIR}/${GEN_THRIFT_OUTPUT_PATH})
  set(include_prefix ${GEN_THRIFT_INCLUDE_PREFIX})
  set(options ${GEN_THRIFT_OPTIONS})
  set(services ${GEN_THRIFT_SERVICES})

  set(include_directories)
  foreach(dir ${GEN_THRIFT_INCLUDE_DIRECTORIES})
    list(APPEND include_directories "--proto_path " "${PROJECT_SOURCE_DIR}/${dir}")
  endforeach()

  set(headers ${output_path}/gen-${language}/${file_name}_constants.h
              ${output_path}/gen-${language}/${file_name}_types.h)
  set(sources ${output_path}/gen-${language}/${file_name}_constants.cpp
              ${output_path}/gen-${language}/${file_name}_types.cpp)

  foreach(service ${services})
    set(headers ${headers} ${output_path}/gen-${language}/${service}.h)
    set(sources ${sources} ${output_path}/gen-${language}/${service}.cpp)
  endforeach()

  set(gen_language ${language})

  add_custom_command(
    OUTPUT ${headers} ${sources}
    COMMAND ${THRIFT_BIN_DIR}/thrift
    ARGS --gen "${gen_language}:${options}" -o ${output_path} ${include_directories}
         "${file_path}/${file_name}.thrift"
    DEPENDS ${THRIFT_BIN_DIR}/thrift "${file_path}/${file_name}.thrift"
    COMMENT "Generating ${file_name} files. Output: ${output_path}")

  add_custom_target(
    ${file_name}-thrift-target
    ALL
    DEPENDS ${headers} ${sources})

  set_source_files_properties(${sources} PROPERTIES GENERATED TRUE)

  set(${file_name}_thrift_sources
      ${sources}
      PARENT_SCOPE)

endfunction(gen_thrift)
