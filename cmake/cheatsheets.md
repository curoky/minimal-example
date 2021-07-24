# CMake

## string

1. replace ':' with ';'

   ```cmake
   STRING(REPLACE ":" ";" SEXY_LIST $ENV{MYINCLUDE})
   ```

## file

1. glob

   ```cmake
   file(GLOB_RECURSE SOURCE_FILES
           path1/*.cpp
           path2/*.cpp
           path3/*.cpp)
   add_executable(test_exec ${SOURCE_FILES})
   ```

2. list dir

   ```cmake
   file(GLOB_RECURSE HEADER_FILES LIST_DIRECTORIES true
           path1
           path2
           path3)
   foreach (header_file ${HEADER_FILES})
       # MESSAGE(STATUS "${header_file}")
   endforeach ()
   ```

## skill

1. set prefix from env

   ```cmake
   string(REPLACE ":" ";" SEXY_LIST $ENV{CMAKE_PREFIX_PATH})
   foreach (path ${SEXY_LIST})
       list(APPEND CMAKE_PREFIX_PATH ${path})
       message(STATUS "include: ${path}")
   endforeach ()
   message(STATUS "include: ${CMAKE_PREFIX_PATH}")
   ```
