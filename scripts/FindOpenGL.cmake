#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if(NOT OPENGL_LIBRARIES)
    enable_language(C)
    if(NOT GLAD_API)
        set(GLAD_API gl:core=3.3)
    endif()
    add_subdirectory(${GVO_SCRIPT_DIR}/../dependencies/glad/cmake ${CMAKE_CURRENT_BINARY_DIR}/glad)
    glad_add_library(glad REPRODUCIBLE API ${GLAD_API} LOCATION ${CMAKE_CURRENT_BINARY_DIR}/glad)
    if(NOT OPENGL_INCLUDE_DIRS)
        set(OPENGL_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/glad/include)
    endif()
    set(OPENGL_LIBRARIES glad)
endif()