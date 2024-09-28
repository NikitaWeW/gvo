macro(gvo_find_dependencies)
    cmake_parse_arguments(GVO "" "" "DEPENDENCIES;SCRIPT_PATHS" ${ARGN})
    add_library(gvo INTERFACE)

    foreach(GVO_DEP_NAME ${GVO_DEPENDENCIES})
        string(TOUPPER ${GVO_DEP_NAME} GVO_DEP_NAME_CAP)
        message(STATUS "Finding ${GVO_DEP_NAME}.")
        foreach(GVO_SCRIPT_DIR ${GVO_SCRIPT_PATHS}) # find find script
            file(GLOB GVO_FIND_SCRIPT "${GVO_SCRIPT_DIR}/Find${GVO_DEP_NAME}.cmake")
            if(GVO_FIND_SCRIPT)
                list(GET GVO_FIND_SCRIPT 0 GVO_FIND_SCRIPT) # leave only the first one.
                break()
            endif()
        endforeach()
        if(GVO_FIND_SCRIPT)
            message(STATUS "Found script: \"${GVO_FIND_SCRIPT}\" for dependency ${GVO_DEP_NAME}.")
            get_filename_component(GVO_SCRIPT_DIR ${GVO_FIND_SCRIPT} DIRECTORY)
            include(${GVO_FIND_SCRIPT})
            unset(GVO_SCRIPT_DIR)
        else()
            message(WARNING "Find script not found for dependency ${GVO_DEP_NAME}!")
            continue() # skip that dependency
        endif()
        message(STATUS "Done finding ${GVO_DEP_NAME}.")
        
        add_library(gvo_${GVO_DEP_NAME} INTERFACE)

        if(DEFINED ${GVO_DEP_NAME_CAP}_LIBRARIES) # link libraries
            target_link_libraries(gvo_${GVO_DEP_NAME} INTERFACE ${${GVO_DEP_NAME_CAP}_LIBRARIES})
        endif()
        if(DEFINED ${GVO_DEP_NAME_CAP}_INCLUDE_DIRS) # include dirs
            target_include_directories(gvo_${GVO_DEP_NAME} INTERFACE ${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS})
            install(DIRECTORY ${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS} DESTINATION gvo/include)
        endif()

        foreach(${GVO_DEP_NAME_CAP}_LIBRARY ${${GVO_DEP_NAME_CAP}_LIBRARIES}) # could be list
            if(TARGET ${${GVO_DEP_NAME_CAP}_LIBRARY})
                add_dependencies(gvo ${${GVO_DEP_NAME_CAP}_LIBRARY})
                install(TARGETS ${${GVO_DEP_NAME_CAP}_LIBRARY} DESTINATION gvo/lib)
            else() # its a file
                set(GVO_ADDITIONAL_LIBRARY_FILES_FOUND) # get all files with lib dll dylib a so framework extensions
                foreach(GVO_LIBRARY_EXTENSION "lib" "dll" "dylib" "a" "so" "framework")
                    get_filename_component(GVO_ADDITIONAL_LIBRARY_FILES_DIR ${${GVO_DEP_NAME_CAP}_LIBRARY} DIRECTORY)  # get directory of library file
                    file(GLOB GVO_ADDITIONAL_LIBRARY_FILES "${GVO_ADDITIONAL_LIBRARY_FILES_DIR}/*.${GVO_LIBRARY_EXTENSION}") # find files with extension i.e. .a -> lib1.dll.a lib2.a
                    list(APPEND GVO_ADDITIONAL_LIBRARY_FILES_FOUND ${GVO_ADDITIONAL_LIBRARY_FILES}) # add these files
                endforeach()
                unset(GVO_ADDITIONAL_LIBRARY_FILES)
                unset(GVO_ADDITIONAL_LIBRARY_FILES_DIR)

                list(REMOVE_DUPLICATES GVO_ADDITIONAL_LIBRARY_FILES_FOUND) # remove duplicates
                install(FILES ${${GVO_DEP_NAME_CAP}_LIBRARY} ${GVO_ADDITIONAL_LIBRARY_FILES_FOUND} ${${GVO_DEP_NAME_CAP}_LIBRARIES_INSTALL} DESTINATION gvo/lib)
                unset(GVO_ADDITIONAL_LIBRARY_FILES_FOUND)
            endif()
        endforeach()

        unset(GVO_FIND_SCRIPT)
    endforeach()
    unset(GVO_DEP_NAME_CAP)
endmacro()