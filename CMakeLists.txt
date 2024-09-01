#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

cmake_minimum_required(VERSION 3.29)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmax-errors=5")
project(gvo VERSION 1.0.0 LANGUAGES CXX)
option(BUILD_VULKAN_LOADER ON "build vulkan loader if needed")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

if(NOT DEFINED SRC)
set(SRC src/main-opengl.cpp)
endif()
if(NOT DEFINED SRC_DEPS)
set(SRC_DEPS src/c-logger/src/logger.o src/c-logger/src/loggerconf.o)
endif()
add_executable(${PROJECT_NAME} ${SRC} ${SRC_DEPS})

if(NOT DEFINED GLFW_INCLUDE_DIR)
    set(GLFW_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/dependencies/glfw/include/)
endif()
if(NOT DEFINED GL_INCLUDE_DIR)
    set(GL_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/dependencies/glad/include/)
endif()
if(NOT DEFINED VULKAN_INCLUDE_DIR)
    set(VULKAN_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers/include/)
endif()
if(NOT DEFINED GLFW_BIN)
    set(GLFW_BIN ${PROJECT_SOURCE_DIR}/dependencies/glfw/lib/libglfw3.a)
endif()
if(NOT DEFINED GL_BIN)
    set(GL_BIN ${PROJECT_SOURCE_DIR}/dependencies/glad/lib/libglad.a)
endif()
if(NOT DEFINED VULKAN_BIN)
    if(EXISTS ${PROJECT_BINARY_DIR}/Vulkan-Loader)
        message(STATUS "vulkan loader already build (if not delete PROJECT_BINARY_DIR/Vulkan-Loader folder).")
    elseif(NOT ${BUILD_VULKAN_LOADER})
        message(STATUS "vulkan loader building is turned off.")
    elseif(EXISTS ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Loader/CMakeLists.txt)
        message(STATUS "building vulkan loader")

        execute_process( # manualy configure and install vulkan headers (i have no idea)
            COMMAND ${CMAKE_COMMAND} -S ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers -B ${PROJECT_BINARY_DIR}/Vulkan-Headers 
                -G ${CMAKE_GENERATOR}
            RESULT_VARIABLE RESULT
        )
        if(NOT ${RESULT} EQUAL 0)
            message(WARNING "failed to configure vulkan headers")
        endif()
        execute_process(
            COMMAND ${CMAKE_COMMAND} --install ${PROJECT_BINARY_DIR}/Vulkan-Headers --prefix ${PROJECT_BINARY_DIR}/Vulkan-Headers/
            RESULT_VARIABLE RESULT
        )
        if(NOT ${RESULT} EQUAL 0)
            message(WARNING "failed to install vulkan headers")
        endif()
        set(VULKAN_INCLUDE_DIR ${PROJECT_BINARY_DIR}/Vulkan-Headers/include)

        # manualy configure and build vulkan loadrer (its easier than subdirectory)
        execute_process(
            COMMAND ${CMAKE_COMMAND} -S ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Loader -B ${PROJECT_BINARY_DIR}/Vulkan-Loader 
                -G ${CMAKE_GENERATOR}
                -D CMAKE_PREFIX_PATH=${PROJECT_BINARY_DIR}/Vulkan-Headers/install/share/cmake/VulkanHeaders
                -D VULKAN_HEADERS_INSTALL_DIR=${PROJECT_BINARY_DIR}/Vulkan-Headers
            RESULT_VARIABLE RESULT
        )
        if(NOT ${RESULT} EQUAL 0)
            message(WARNING "failed to configure vulkan loader")
        endif()
        execute_process(
            COMMAND ${CMAKE_COMMAND} --build ${PROJECT_BINARY_DIR}/Vulkan-Loader
            RESULT_VARIABLE RESULT
        )
        if(NOT ${RESULT} EQUAL 0)
            message(WARNING "failed to build vulkan loader")
        endif()
        execute_process(
            COMMAND ${CMAKE_COMMAND} --install ${PROJECT_BINARY_DIR}/Vulkan-Loader --prefix ${PROJECT_BINARY_DIR}/Vulkan-Loader/install --config Debug # for some reason it builds loader in Vulkan-Loader/loader/Debug
            RESULT_VARIABLE RESULT
        )
        if(NOT ${RESULT} EQUAL 0)
            message(WARNING "failed to install vulkan loader")
        endif()
    else()
        message(WARNING "unable to build vulkan loader")
        set(VULKAN_BIN ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Loader/build/install/lib/vulkan-1.lib)
    endif()
    file(GLOB VULKAN_BIN ${PROJECT_BINARY_DIR}/Vulkan-Loader/install/lib/*vulkan-1*)
    message(>>>>>>>>>>>>>>>>>>>>>>>>>>>>${VULKAN_BIN})
endif()

set(GLFW_EXISTS (EXISTS ${GLFW_INCLUDE_DIR} AND EXISTS ${GLFW_BIN}))
set(VULKAN_EXISTS (EXISTS ${VULKAN_INCLUDE_DIR} AND EXISTS ${VULKAN_BIN}))
set(GL_EXISTS (EXISTS ${GL_INCLUDE_DIR} AND EXISTS ${GL_BIN}))

if(NOT ${VULKAN_EXISTS} AND NOT ${GL_EXISTS})
message(FATAL_ERROR "no graphics api found.")
endif()
if(${GLFW_EXISTS})
    message(STATUS "glfw found.")
    target_include_directories(${PROJECT_NAME} PRIVATE ${GLFW_INCLUDE_DIR})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${GLFW_BIN})
else()
    message(FATAL_ERROR "glfw not found.")
endif()
if(${VULKAN_EXISTS}) 
    message(STATUS "vulkan found.")
    target_include_directories(${PROJECT_NAME} PRIVATE ${VULKAN_INCLUDE_DIR})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${VULKAN_BIN})
endif()
if(${GL_EXISTS}) 
    message(STATUS "gl found.")
    target_include_directories(${PROJECT_NAME} PRIVATE ${GL_INCLUDE_DIR})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${GL_BIN})
endif()

if (WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE winmm gdi32)
elseif(UNIX)
    target_link_libraries(${PROJECT_NAME} PRIVATE pthread dl)
endif()