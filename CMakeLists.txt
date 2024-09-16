#Copyright (c) 2024 Nikita Martynau (https://opensource.org/license/mit)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set(LIBRARY_EXTENSIONS "lib" "dll" "dylib" "a" "so" "framework")

project(gvo)
add_library(gvo INTERFACE)

foreach(GVO_DEP_NAME ${GVO_DEPS})
    string(TOUPPER ${GVO_DEP_NAME} GVO_DEP_NAME_CAP)

    message(STATUS "Finding ${GVO_DEP_NAME}")
    include("find-scripts/Find${GVO_DEP_NAME}.cmake")
    message(STATUS "Done finding ${GVO_DEP_NAME}")
    
    if(DEFINED ${GVO_DEP_NAME_CAP}_LIBRARIES) # link libraries
        target_link_libraries(gvo INTERFACE ${${GVO_DEP_NAME_CAP}_LIBRARIES})
    endif()
    if(DEFINED ${GVO_DEP_NAME_CAP}_INCLUDE_DIRS) # include dirs
        target_include_directories(gvo INTERFACE ${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS})
        install(DIRECTORY ${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS} DESTINATION gvo/include)
    endif()


    foreach(${GVO_DEP_NAME_CAP}_LIBRARY ${${GVO_DEP_NAME_CAP}_LIBRARIES}) # install libraries
        if(TARGET ${${GVO_DEP_NAME_CAP}_LIBRARY})
            install(TARGETS ${${GVO_DEP_NAME_CAP}_LIBRARY} DESTINATION gvo/lib)
        else()
            set(ADDITIONAL_LIBRARY_FILES_FOUND)
            foreach(LIBRARY_EXTENSION ${LIBRARY_EXTENSIONS})
                get_filename_component(ADDITIONAL_LIBRARY_FILES_DIR ${${GVO_DEP_NAME_CAP}_LIBRARY} DIRECTORY)

                file(GLOB ADDITIONAL_LIBRARY_FILES "${ADDITIONAL_LIBRARY_FILES_DIR}/*.${LIBRARY_EXTENSION}*")
                list(APPEND ADDITIONAL_LIBRARY_FILES_FOUND ${ADDITIONAL_LIBRARY_FILES})
            endforeach()
            unset(ADDITIONAL_LIBRARY_NAME_FILES)

            install(FILES ${${GVO_DEP_NAME_CAP}_LIBRARY} ${ADDITIONAL_LIBRARY_FILES_FOUND} ${${GVO_DEP_NAME_CAP}_FILES_TO_INSTALL} DESTINATION gvo/lib)
        endif()
    endforeach()
endforeach()
unset(ADDITIONAL_LIBRARY_FILES_FOUND)
unset(ADDITIONAL_LIBRARY_FILES_DIR)
unset(GVO_DEP_NAME_CAP)

unset(LIBRARY_EXTENSIONS)
