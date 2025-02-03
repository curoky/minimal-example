function(gen_fbthrift)
  cmake_parse_arguments(
    GEN_FBTHRIFT # Prefix
    "" # Options
    "FILE_NAME;FILE_PATH;LANGUAGE;OUTPUT_PATH;INCLUDE_PREFIX;OPTIONS" # One Value args
    "SERVICES;INCLUDE_DIRECTORIES" # Multi-value args
    "${ARGN}")

  set(file_name ${GEN_FBTHRIFT_FILE_NAME})
  set(file_path ${PROJECT_SOURCE_DIR}/${GEN_FBTHRIFT_FILE_PATH})
  set(language ${GEN_FBTHRIFT_LANGUAGE})
  set(output_path ${PROJECT_SOURCE_DIR}/${GEN_FBTHRIFT_OUTPUT_PATH})
  set(include_prefix ${GEN_FBTHRIFT_INCLUDE_PREFIX})
  set(options ${GEN_FBTHRIFT_OPTIONS})
  set(services ${GEN_FBTHRIFT_SERVICES})

  set(include_directories)
  foreach(dir ${GEN_FBTHRIFT_INCLUDE_DIRECTORIES})
    list(APPEND include_directories "-I" "${PROJECT_SOURCE_DIR}/${dir}")
  endforeach()

  set(headers
      ${output_path}/gen-${language}/${file_name}_constants.h
      ${output_path}/gen-${language}/${file_name}_data.h
      ${output_path}/gen-${language}/${file_name}_metadata.h
      ${output_path}/gen-${language}/${file_name}_types.h
      ${output_path}/gen-${language}/${file_name}_types.tcc)
  set(sources
      ${output_path}/gen-${language}/${file_name}_constants.cpp
      ${output_path}/gen-${language}/${file_name}_data.cpp
      ${output_path}/gen-${language}/${file_name}_types.cpp)

  if(NOT "${options}" MATCHES "no_metadata")
    set(sources ${sources} ${output_path}/gen-${language}/${file_name}_metadata.cpp)
  endif()

  foreach(service ${services})
    set(headers
        ${headers}
        ${output_path}/gen-${language}/${service}.h
        ${output_path}/gen-${language}/${service}.tcc
        ${output_path}/gen-${language}/${service}AsyncClient.h
        ${output_path}/gen-${language}/${service}_custom_protocol.h)
    set(sources ${sources} ${output_path}/gen-${language}/${service}.cpp
                ${output_path}/gen-${language}/${service}AsyncClient.cpp)
  endforeach()

  if("${include_prefix}" STREQUAL "")
    set(include_prefix_text "")
  else()
    set(include_prefix_text "include_prefix=${include_prefix}")
    if(NOT "${options}" STREQUAL "")
      set(include_prefix_text ",${include_prefix_text}")
    endif()
  endif()

  set(gen_language ${language})
  if("${language}" STREQUAL "cpp2")
    set(gen_language "mstch_cpp2")
  elseif("${language}" STREQUAL "py3")
    set(gen_language "mstch_py3")
    file(WRITE "${output_path}/gen-${language}/${file_name}/__init__.py" )
  endif()

  add_custom_command(
    OUTPUT ${headers} ${sources}
    COMMAND thrift1
    ARGS --gen "${gen_language}:${options}${include_prefix_text}" -o ${output_path}
         ${include_directories} "${file_path}/${file_name}.thrift"
    DEPENDS thrift1 "${file_path}/${file_name}.thrift"
    COMMENT "Generating ${file_name} files. Output: ${output_path}")

  add_custom_target(
    ${file_name}-fbthrift-target
    ALL
    DEPENDS ${headers} ${sources})

  set(${file_name}_fbthrift_sources
      ${sources}
      PARENT_SCOPE)

  # not work for parent scope
  # set_source_files_properties(${file_name}_fbthrift_sources PROPERTIES GENERATED TRUE)
endfunction(gen_fbthrift)
