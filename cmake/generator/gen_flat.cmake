function(gen_flat)
  cmake_parse_arguments(
    GEN_FLAT # Prefix
    "" # Options
    "FILE_NAME;FILE_PATH;LANGUAGE;OUTPUT_PATH;INCLUDE_PREFIX;OPTIONS" # One Value args
    "INCLUDE_DIRECTORIES" # Multi-value args
    "${ARGN}")

  set(file_name ${GEN_FLAT_FILE_NAME})
  set(file_path ${PROJECT_SOURCE_DIR}/${GEN_FLAT_FILE_PATH})
  set(language ${GEN_FLAT_LANGUAGE})
  set(output_path ${PROJECT_SOURCE_DIR}/${GEN_FLAT_OUTPUT_PATH})
  # set(include_prefix ${GEN_FLAT_INCLUDE_PREFIX})
  # set(options ${GEN_FLAT_OPTIONS})

  set(headers ${output_path}/gen-${language}/${file_name}_generated.h)

  set(gen_language ${language})

  add_custom_command(
    OUTPUT ${headers}
    COMMAND flatc
    ARGS -o "${output_path}/gen-${gen_language}" "--${gen_language}" "${file_path}/${file_name}.fbs"
    DEPENDS flatc "${file_path}/${file_name}.fbs"
    COMMENT "Generating ${file_name} files. Output: ${output_path}")

  set_source_files_properties(${headers} PROPERTIES GENERATED TRUE)

  add_custom_target(
    ${file_name}-flat-target
    ALL
    DEPENDS ${headers})

endfunction(gen_flat)
