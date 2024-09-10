﻿#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if(NOT DEFINED VULKAN_INCLUDE_DIRS)
    set(VULKAN_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers/include/)
endif()

if(NOT DEFINED VULKAN_GENERATOR)
    set(VULKAN_GENERATOR ${CMAKE_GENERATOR})
endif()

if(NOT DEFINED VULKAN_LIBRARIES)
    execute_process( # manualy configure and install vulkan headers (i have no idea)
        COMMAND ${CMAKE_COMMAND} -S ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers -B ${CMgiAKE_CURRENT_BINARY_DIR}/Vulkan-Headers 
            -G ${VULKAN_GENERATOR}
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
    if(NOT DEFINED VULKAN_INCLUDE_DIR)
        set(VULKAN_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers/include)
    endif()

    set(VULKAN_HEADERS_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/Vulkan-Headers)
    add_subdirectory(dependencies/vulkan/Vulkan-Loader ${PROJECT_BUILD_DIR}/Vulkan-Loader)
    set(VULKAN_LIBRARIES vulkan)
    unset(RESULT)
endif()