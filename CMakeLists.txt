#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

add_library(gvo INTERFACE)

option(OPENGL ON)
option(VULKAN ON)

if(VULKAN)
    message(STATUS "Finding Vulkan")
    include(find-scripts/FindVulkan.cmake)
endif()
if(OPENGL)
    message(STATUS "Finding OpenGL")
    include(find-scripts/FindOpenGL.cmake)
endif()
message(STATUS "Finding GLFW")
include(find-scripts/FindGLFW.cmake)
message(STATUS "Finding Logger")
include(find-scripts/FindLogger.cmake)

target_link_libraries(gvo INTERFACE ${GLFW_LIBRARIES} INTERFACE ${VULKAN_LIBRARIES} INTERFACE ${OPENGL_LIBRARIES} INTERFACE ${LOGGER_LIBRARIES})
target_include_directories(gvo INTERFACE ${GLFW_INCLUDE_DIRS} INTERFACE ${VULKAN_INCLUDE_DIRS} INTERFACE ${OPENGL_INCLUDE_DIRS} INTERFACE ${LOGGER_INCLUDE_DIRS})