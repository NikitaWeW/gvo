#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if(NOT DEFINED ASSIMP_LIBRARIES)
    if(NOT DEFINED ASSIMP_BUILD_TESTS)    
        set(ASSIMP_BUILD_TESTS OFF)
    endif()
    if(NOT DEFINED ASSIMP_WARNINGS_AS_ERRORS)
        set(ASSIMP_WARNINGS_AS_ERRORS OFF)
    endif()
    if(NOT DEFINED ASSIMP_BUILD_ASSIMP_VIEW)
        set(ASSIMP_BUILD_ASSIMP_VIEW OFF)
    endif()

    add_subdirectory(dependencies/assimp ${CMAKE_CURRENT_BINARY_DIR}/assimp)
    set(ASSIMP_LIBRARIES assimp CACHE STRING "path to assimp libraries")
    if(NOT DEFINED ASSIMP_INCLUDE_DIRS) # assimp generates some headers for no fucking reason. 
        set(ASSIMP_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/assimp/include/;${CMAKE_CURRENT_SOURCE_DIR}/dependencies/assimp/include/ CACHE STRING "path to assimp include dirs")
    endif()
endif()

if(NOT DEFINED ASSIMP_INCLUDE_DIRS)
    set(ASSIMP_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/assimp/include/ CACHE STRING "path to assimp include dirs")
endif()

list(GET ASSIMP_LIBRARIES 0 ASSIMP_LIBRARIES_0)
get_filename_component(ASSIMP_LIB_DIR ${ASSIMP_LIBRARIES_0} DIRECTORY)
file(GLOB ASSIMP_FILES_TO_INSTALL "${ASSIMP_LIB_DIR}/../bin/*assimp*")
unset(ASSIMP_LIB_DIR)