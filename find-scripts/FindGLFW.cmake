
if(NOT DEFINED GLFW_INCLUDE_DIRS)
    set(GLFW_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/glfw/include/)
endif()
if(NOT DEFINED GLFW_LIBRARIES)
    add_subdirectory(dependencies/glfw ${PROJECT_BINARY_DIR}/glfw)
    set(GLFW_LIBRARIES glfw)
endif()