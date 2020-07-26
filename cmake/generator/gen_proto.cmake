function(gen_proto)
  cmake_parse_arguments(
    GEN_PROTO # Prefix
    "" # Options
    "FILE_NAME;FILE_PATH;LANGUAGE;OUTPUT_PATH;INCLUDE_PREFIX;OPTIONS" # One Value args
    "INCLUDE_DIRECTORIES" # Multi-value args
    "${ARGN}")

  set(file_name ${GEN_PROTO_FILE_NAME})
  set(file_path ${PROJECT_SOURCE_DIR}/${GEN_PROTO_FILE_PATH})
  set(language ${GEN_PROTO_LANGUAGE})
  set(output_path ${PROJECT_SOURCE_DIR}/${GEN_PROTO_OUTPUT_PATH})
  # set(include_prefix ${GEN_PROTO_INCLUDE_PREFIX})
  # set(options ${GEN_PROTO_OPTIONS})

  set(include_directories)
  foreach(dir ${GEN_PROTO_INCLUDE_DIRECTORIES})
    list(APPEND include_directories "--proto_path=${dir}")
  endforeach()

  set(headers ${output_path}/gen-${language}/${file_name}.pb.h)
  set(sources ${output_path}/gen-${language}/${file_name}.pb.cc)

  set(gen_language ${language})

  add_custom_command(
    OUTPUT ${headers} ${sources}
    COMMAND protoc
    ARGS "--proto_path" "${file_path}" "${include_directories}" "--${gen_language}_out"
         "${output_path}/gen-${gen_language}" "${file_name}.proto"
    DEPENDS protoc "${file_path}/${file_name}.proto"
    COMMENT "Generating ${file_name} files. Output: ${output_path}")
  add_custom_target(
    ${file_name}-proto-target
    ALL
    DEPENDS ${headers} ${sources})

  set_source_files_properties(${sources} PROPERTIES GENERATED TRUE)

  set(${file_name}_proto_sources
      ${sources}
      PARENT_SCOPE)

endfunction(gen_proto)
