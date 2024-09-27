#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

project(gvo)
add_library(gvo INTERFACE)

foreach(GVO_DEP_NAME ${GVO_DEPS})
    string(TOUPPER ${GVO_DEP_NAME} GVO_DEP_NAME_CAP)

    message(STATUS "Finding ${GVO_DEP_NAME}.")
    foreach(GVO_DIR ${GVO_SCRIPT_PATHS} "scripts") # find find script
        file(GLOB GVO_FIND_SCRIPT "${GVO_DIR}/Find${GVO_DEP_NAME}.cmake")
        if(GVO_FIND_SCRIPT)
            list(GET GVO_FIND_SCRIPT 0 GVO_FIND_SCRIPT) # leave only the first one.
            break()
        endif()
    endforeach()
    unset(GVO_DIR)

    if(GVO_FIND_SCRIPT)
        message(STATUS "Found script: \"${GVO_FIND_SCRIPT}\" for dependency ${GVO_DEP_NAME}.")
        include(${GVO_FIND_SCRIPT})
    else()
        message(WARNING "Find script not found for dependency ${GVO_DEP_NAME}!")
        continue() # skip that dependency
    endif()
    message(STATUS "Done finding ${GVO_DEP_NAME}.")
    
    if(DEFINED ${GVO_DEP_NAME_CAP}_LIBRARIES) # link libraries
        target_link_libraries(gvo INTERFACE ${${GVO_DEP_NAME_CAP}_LIBRARIES})
    endif()
    if(DEFINED ${GVO_DEP_NAME_CAP}_INCLUDE_DIRS) # include dirs
        target_include_directories(gvo INTERFACE ${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS})
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

            install(FILES ${${GVO_DEP_NAME_CAP}_LIBRARY} ${GVO_ADDITIONAL_LIBRARY_FILES_FOUND} ${${GVO_DEP_NAME_CAP}_LIBRARIES_INSTALL} DESTINATION gvo/lib)
            unset(GVO_ADDITIONAL_LIBRARY_FILES_FOUND)
        endif()
    endforeach()

    unset(GVO_FIND_SCRIPT)
endforeach()
unset(GVO_DEP_NAME_CAP)