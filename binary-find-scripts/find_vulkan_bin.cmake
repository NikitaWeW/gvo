if(NOT DEFINED VULKAN_BUILD_GENERATOR)
    set(VULKAN_BUILD_GENERATOR ${CMAKE_GENERATOR})
endif()

if(EXISTS ${PROJECT_BINARY_DIR}/Vulkan-Loader)
    message(STATUS "vulkan loader already build (if not delete PROJECT_BINARY_DIR/Vulkan-Loader folder).")
elseif(NOT BUILD_VULKAN_LOADER)
    message(STATUS "vulkan loader building is turned off.")
elseif(EXISTS ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Loader/CMakeLists.txt)
    message(STATUS "building vulkan loader")

    execute_process( # manualy configure and install vulkan headers (i have no idea)
        COMMAND ${CMAKE_COMMAND} -S ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers -B ${PROJECT_BINARY_DIR}/Vulkan-Headers 
            -G ${VULKAN_BUILD_GENERATOR}
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
            -G ${VULKAN_BUILD_GENERATOR}
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