# GVO - dependency manager + [setup](#currently-supported-dependencies)
This project provides cmakelists to orgenise your dependencies, [these dependencies](#currently-supported-dependencies), and scripts to build and find them. 

You set the GVO_DEPS and add gvo as a subdirectory. gvo will iterate over GVO_DEPS and automatically include all the necessary scripts to set [output variables](#variables) and use them.

You can use it however you like, but i recommend adding gvo as a submodule and using it as a cmake subdirectory.

For details, see [here](#variables).

## Using gvo
First, gvo uses git submodules, so make sure you are managing them correctly.

Now, you **must** to set [GVO_DEPS variable](#variables):
``` cmake
set(GVO_DEPS Vulkan GLFW assimp GLM imgui) # set required  dependencies

#OPTIONAL: specify additional find script paths (see variables)
set(GVO_SCRIPT_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/find-scripts)
```
Then, add gvo as subdirectory:
``` cmake
add_subdirectory(gvo) # Add gvo as a subdirectory. This will create a "gvo" interface target.
```
You can use [variables](#variables) however you like:
``` cmake
# print all the dependencies, include dirs and library files
foreach(GVO_DEP_NAME ${GVO_DEPS})
    string(TOUPPER ${GVO_DEP_NAME} GVO_DEP_NAME_CAP)
    message("${GVO_DEP_NAME}:")
    message("\tlib:     \"${${GVO_DEP_NAME_CAP}_LIBRARIES}\"")
    message("\tinclude: \"${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS}\"")
endforeach()

add_executable(mymain src/main.cpp)

target_link_libraries(mymain gvo) # link to gvo target. this will link both include dirs and libraris.
```

example output:
```
OpenGL:
        lib:     "glad" <- target name.
        include: "D:/gladopengl/include"
GLFW:
        lib:     "glfw"
        include: "D:/glfw/include"
Logger:
        lib:     "logger"
        include: "D:/gvo/dependencies/c-logger/src/"
GLM:
        lib:     "" <- header only. not initialised.
        include: "D:/gvo/dependencies/glm/glm/"
OpenAL:
        lib:     "OpenAL"
        include: "D:/gvo/dependencies/OpenAL/include/"
assimp:
        lib:     "assimp"
        include: "D:/gvo/build/gvo/assimp/include/"
```
## Currently supported dependencies (names):
- [assimp](https://github.com/assimp/assimp)
- [GLFW](https://github.com/glfw/glfw)
- [GLM](https://github.com/icaven/glm)
- [Logger](https://github.com/yksz/c-logger)
- [OpenAL](https://github.com/kcat/openal-soft)
- [OpenGL](https://glad.dav1d.de/)
- [Vulkan](https://github.com/KhronosGroup/Vulkan-Headers)

## Variables
`<name>` is the name of the library e.g. `VULKAN_INCLUDE_DIRS`, `VULKAN_LIBRARIES`. 

These variables are used as inputs in cmakelists and are set before adding gvo as a subdirectory:
| variable | description |
| :- | :- |
| `GVO_DEPS`| The `GVO_DEPS` list contains [names of dependencies](#currently-supported-dependencies). It is used to locate and include **find scripts** named `Find<name>.cmake`, e.g. `FindVulkan.cmake`, `FindGLFW.cmake`, `Findassimp.cmake`. |
| `GVO_SCRIPT_PATHS` | Path to directory containing additional scripts not provided by gvo, e.g. `${CMAKE_SOURCE_DIR}/find-scripts` gvo will look for find scripts in this directory. |
---

These variables are set by the find script. They are already used by gvo target, but you can use them too:
| variable | description |
| :- | :- |
| `<name>_INCLUDE_DIRS` | variable / list of dependency include directories. Used as include directories in gvo target. |
| `<name>_LIBRARIES` | variable / list with the library files of the dependency. gvo target will link to them. Will be installed to `gvo/lib`. |
---

There are used to install dependencies:
| variable | description |
| :- | :- |
| `<name>_LIBRARY_FILES_TO_INSTALL` | variable / list with the library files to install in `gvo/lib` |
| `<name>_FILES_TO_INSTALL` | variable / list with the additional files to install in `gvo` |
| `<name>_LIBRARIES_INSTALL` | variable / list with the additional directories to install in `gvo` |
---

### Some important points
- gvo also installs any file in the `<name>_LIBRARIES` directory with `.lib .dll .dylib .a .so .framework` extensions (including double extensions, e.g. `.dll.a`) into the `gvo/lib` directory.

- gvo will only use initialised (`if(VAR)`) variables.

- User / cmake scripts could also set `<name>_INCLUDE_DIRS` and `<name>_LIBRARIES`, and these should not be overridden (currently they are not. It depends on the find script). 
I recommend using the following in find scripts
``` cmake
if(NOT VULKAN_INCLUDE_DIRS)
# do someting and set VULKAN_INCLUDE_DIRS
endif()
```

*if  you found any kind of bug / flaw or have questions please, create github issue or maybe even a pr )*


