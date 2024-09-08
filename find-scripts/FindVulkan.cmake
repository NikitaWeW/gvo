if(NOT DEFINED VULKAN_INCLUDE_DIRS)
    set(VULKAN_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers/include/)
endif()

if(NOT DEFINED VULKAN_BUILD_GENERATOR)
    set(VULKAN_BUILD_GENERATOR ${CMAKE_GENERATOR})
endif()

if(NOT DEFINED VULKAN_LIBRARIES)
    execute_process( # manualy configure and install vulkan headers (i have no idea)
        COMMAND ${CMAKE_COMMAND} -S ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers -B ${PROJECT_BINARY_DIR}/Vulkan-Headers 
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
    if(NOT DEFINED VULKAN_INCLUDE_DIR)
        set(VULKAN_INCLUDE_DIRS ${PROJECT_BINARY_DIR}/Vulkan-Headers/include)
    endif()

    set(VULKAN_HEADERS_INSTALL_DIR ${PROJECT_BINARY_DIR}/Vulkan-Headers)
    add_subdirectory(dependencies/vulkan/Vulkan-Loader ${PROJECT_BUILD_DIR}/Vulkan-Loader)
    set(VULKAN_LIBRARIES vulkan)
endif()