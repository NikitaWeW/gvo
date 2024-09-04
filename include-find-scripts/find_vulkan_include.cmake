if(NOT DEFINED VULKAN_INCLUDE_DIR) # may be defined by find bin
    set(VULKAN_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/dependencies/vulkan/Vulkan-Headers/include/)
endif()