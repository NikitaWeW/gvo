option(GVO_SILENT True "silent mode. if silent, all messages from gvo will be DEBUG, STATUS else.")
if(GVO_SILENT)
    set(GVO_LEVEL DEBUG)
else()
    set(GVO_LEVEL STATUS)
endif()

macro(gvo_set_include_dir GVO_NAME GVO_SCRIPT_PATHS_ARG)
    message(${GVO_LEVEL} "finding ${GVO_NAME} include directory...")
    string(TOUPPER ${GVO_NAME} GVO_NAME_UPPER) # GVO_NAME but cap
    
    if(NOT DEFINED "${GVO_NAME_UPPER}_INCLUDE_DIR") # maybe include directory already specified
        set(GVO_SCRIPT_PATHS ${GVO_SCRIPT_PATHS_ARG}) # set script file search paths
        list(APPEND GVO_SCRIPT_PATHS ${GVO_DEFAULT_SCRIPT_PATHS})
        
        foreach(GVO_PATH ${GVO_SCRIPT_PATHS}) # 
            file(GLOB GVO_FIND_FILES "${GVO_PATH}/find*${GVO_NAME}*include.cmake")
            if(GVO_FIND_FILES)
                break() # it will select only first script anyway
            endif()
        endforeach()
            
        if(GVO_FIND_FILES)
            list(GET GVO_FIND_FILES 0 GVO_FIND_FILE) # select first script
            message(${GVO_LEVEL} "found include path find script: ${GVO_FIND_FILE}. executing...")
            include(${GVO_FIND_FILE})
        else()
            message(${GVO_LEVEL} "include path find script(s) not found!")
        endif()
    endif()    

    unset(GVO_NAME_UPPER)
    unset(GVO_SCRIPT_PATHS)
endmacro()
macro(gvo_set_bin GVO_NAME GVO_SCRIPT_PATHS_ARG)
    message(${GVO_LEVEL} "finding ${GVO_NAME} include directory...")
    string(TOUPPER ${GVO_NAME} GVO_NAME_UPPER) # GVO_NAME but cap
    
    if(NOT DEFINED "${GVO_NAME_UPPER}_BIN") # maybe include directory already specified
        set(GVO_SCRIPT_PATHS ${GVO_SCRIPT_PATHS_ARG}) # set script file search paths
        list(APPEND GVO_SCRIPT_PATHS ${GVO_DEFAULT_SCRIPT_PATHS})
        
        foreach(GVO_PATH ${GVO_SCRIPT_PATHS}) # 
            file(GLOB GVO_FIND_FILES "${GVO_PATH}/find*${GVO_NAME}*bin.cmake")
            if(GVO_FIND_FILES)
                break() # it will select only first script anyway
            endif()
        endforeach()
            
        if(GVO_FIND_FILES)
            list(GET GVO_FIND_FILES 0 GVO_FIND_FILE) # select first script
            message(${GVO_LEVEL} "found binaris path find script: ${GVO_FIND_FILE}. executing...")
            include(${GVO_FIND_FILE})
        else()
            message(${GVO_LEVEL} "include path find script(s) not found!")
        endif()
    endif()    

    unset(GVO_NAME_UPPER)
    unset(GVO_SCRIPT_PATHS)
endmacro()

macro(gvo_validate GVO_NAME) 
    string(TOUPPER ${GVO_NAME} GVO_NAME_UPPER)
    if(EXISTS "${${GVO_NAME_UPPER}_INCLUDE_DIR}" AND EXISTS "${${GVO_NAME_UPPER}_BIN}")
        set(${GVO_NAME_UPPER}_EXISTS True)
    else()
        set(${GVO_NAME_UPPER}_EXISTS False)
    endif()
    unset(GVO_NAME_UPPER)
endmacro()

macro(gvo_find GVO_NAME GVO_SCRIPT_PATHS)
    gvo_set_include_dir("${GVO_NAME}" "${GVO_SCRIPT_PATHS}")
    gvo_set_bin("${GVO_NAME}" "${GVO_SCRIPT_PATHS}")
    gvo_validate("${GVO_NAME}")
endmacro()