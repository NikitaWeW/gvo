#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if((NOT VULKAN_INCLUDE_DIRS OR NOT VULKAN_LIBRARIES) AND NOT EXISTS ${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Headers)
    FetchContent_Populate( # i wish i could use FetchContent_Declare and FetchContent_MakeAvailable... 
        vulkan-headers
        GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Headers.git
        SOURCE_DIR ${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Headers
        BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers
    )
endif()

if(NOT VULKAN_INCLUDE_DIRS)
    set(VULKAN_INCLUDE_DIRS ${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Headers/include/ CACHE STRING "vulkan include dirs")
endif()

if(NOT VULKAN_LIBRARIES)
    enable_language(C)    
    execute_process( # manualy configure and install vulkan headers (i have no idea)
        COMMAND ${CMAKE_COMMAND} -S ${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Headers -B ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers 
            -G ${CMAKE_GENERATOR}
            -D CMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
        RESULT_VARIABLE RESULT
    )
    if(NOT ${RESULT} EQUAL 0)
        message(WARNING "failed to configure vulkan headers")
    else()
        execute_process(
            COMMAND ${CMAKE_COMMAND} --install ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers --prefix ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers/
            RESULT_VARIABLE RESULT
        )
    endif()
    if(NOT ${RESULT} EQUAL 0)
        message(WARNING "failed to install vulkan headers")
    endif()
    if(NOT VULKAN_INCLUDE_DIR)
        set(VULKAN_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers/include)
    endif()

    set(VULKAN_HEADERS_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers)
    if(NOT EXISTS ${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Loader)
        FetchContent_Populate(
            vulkan-loader
            GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Loader.git
            GIT_TAG main
            SOURCE_DIR ${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Loader/
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Loader
        )
    endif()
    add_subdirectory(${GVO_SCRIPT_DIR}/../dependencies/Vulkan-Loader ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Loader)
    set(VULKAN_LIBRARIES vulkan CACHE STRING "vulkan libraries")
    unset(RESULT)
endif()