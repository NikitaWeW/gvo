#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

include(gvo.cmake)
cmake_minimum_required(VERSION 3.29)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
project(gvo VERSION 1.0.0 LANGUAGES CXX)
option(BUILD_VULKAN_LOADER ON "build vulkan loader if needed")

if(NOT DEFINED SRC)
    set(SRC src/main-opengl.cpp)
endif()
if(NOT DEFINED SRC_DEPS)
    set(SRC_DEPS src/c-logger/src/logger.o src/c-logger/src/loggerconf.o)
endif()
add_executable(${PROJECT_NAME} ${SRC} ${SRC_DEPS})

set(GVO_DEFAULT_SCRIPT_PATHS ${PROJECT_SOURCE_DIR};binary-find-scripts;include-find-scripts)

gvo_find(glfw "")
gvo_find(vulkan "")
gvo_find(opengl include-find-scripts)

macro(connect TARGET_NAME LIBRARY_NAME FATAL)
    string(TOUPPER ${LIBRARY_NAME} LIBRARY_NAME_UPPER)
    if(${${LIBRARY_NAME_UPPER}_EXISTS})
        message(STATUS "${LIBRARY_NAME} found.")
        target_include_directories(${PROJECT_NAME} PRIVATE ${${LIBRARY_NAME_UPPER}_INCLUDE_DIR})
        target_link_libraries(${PROJECT_NAME} PRIVATE ${${LIBRARY_NAME_UPPER}_BIN})
    else()
        if(${FATAL})
            message(FATAL_ERROR "${LIBRARY_NAME} not found!")
        endif()
    endif()
    unset(NAME_UPPER)
endmacro()

if(NOT VULKAN_EXISTS AND NOT OPENGL_EXISTS)
    message(FATAL_ERROR "no graphics api found.")
endif()

message(STATUS "GLFW -- include: \"${GLFW_INCLUDE_DIR}\" bin: \"${GLFW_BIN}\" exists: <${GLFW_EXISTS}>")
connect(${PROJECT_NAME} GLFW True)
message(STATUS "Vulkan -- include: \"${VULKAN_INCLUDE_DIR}\" bin: \"${VULKAN_BIN}\" exists: <${VULKAN_EXISTS}>")
connect(${PROJECT_NAME} Vulkan False)
message(STATUS "OpenGL -- include: \"${OPENGL_INCLUDE_DIR}\" bin: \"${OPENGL_BIN}\" exists: <${OPENGL_EXISTS}>")
connect(${PROJECT_NAME} OpenGL False)

if (WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE winmm gdi32)
elseif(UNIX)
    target_link_libraries(${PROJECT_NAME} PRIVATE pthread dl)
endif()