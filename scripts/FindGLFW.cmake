﻿#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if(NOT GLFW_INCLUDE_DIRS OR NOT GLFW_LIBRARIES)
    FetchContent_Populate(
        glfw
        GIT_REPOSITORY https://github.com/glfw/glfw.git
        SOURCE_DIR ${GVO_SCRIPT_DIR}/../dependencies/glfw
        BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/glfw
    )
endif()

if(NOT GLFW_INCLUDE_DIRS)
    enable_language(C)
    set(GLFW_INCLUDE_DIRS ${GVO_SCRIPT_DIR}/../dependencies/glfw/include/ CACHE STRING "glfw include dirs")
endif()
if(NOT GLFW_LIBRARIES)
    add_subdirectory(dependencies/glfw ${CMAKE_CURRENT_BINARY_DIR}/glfw)
    set(GLFW_LIBRARIES glfw CACHE STRING "glfw libraries")
endif()