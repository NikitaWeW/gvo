﻿if(NOT DEFINED LOGGER_INCLUDE_DIRS)
    set(LOGGER_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/c-logger/src/)
endif()
if(NOT DEFINED LOGGER_LIBRARIES)
    add_subdirectory(dependencies/c-logger "${PROJECT_BINARY_DIR}/c-logger")
    if(BUILD_SHARED_LIBS)
        set(LOGGER_LIBRARIES logger)
    else()
        set(LOGGER_LIBRARIES logger_static)
    endif()
endif()