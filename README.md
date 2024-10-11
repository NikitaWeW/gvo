# GVO - dependency manager + [setup](#currently-provided-dependencies-names)
This project provides a cmake module for organising your dependencies, as well as [these dependencies](#currently-provided-dependencies-names) for graphical programming, and scripts to build and find them. 

Basically, gvo looks for cmake scripts in given directories for each given dependency, and includes them.

- [Using gvo](#using-gvo)
- [Currently provided dependencies](#currently-provided-dependencies-names)
- [Variables](#variables)
- [Some important points](#some-important-points)
- [Troubleshooting](#troubleshooting)

## Using gvo
gvo does **not** use submodules anymore.

Include `gvo.cmake` file:
``` cmake
include(gvo/gvo.cmake)
```
`gvo_find_dependencies(DEPENDENCIES <dep1>... SCRIPT_DIRS <path1>...)`

Basically, this macro finds and includes cmake scripts that prepare and add dependencies. see [here](#variables) for more information.

- The `DEPENDENCIES` list contains [dependency names](#currently-provided-dependencies-names). It is used to locate and include **find scripts** named `Find<name>.cmake`, e.g. `FindVulkan.cmake`, `FindGLFW.cmake`, `Findassimp.cmake`.

- SCRIPT_DIRS are paths to directories containing scripts. gvo will look for find scripts in these directories. e.g. `${CMAKE_SOURCE_DIR}/find-scripts`, `gvo/scripts`. 

``` cmake
gvo_find_dependencies(DEPENDENCIES OpenGL GLFW assimp OpenAL GLM imgui SCRIPT_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/scripts ${CMAKE_CURRENT_SOURCE_DIR}/gvo/scripts)
```

After that, you can just link to `gvo` interface library or link to specific dependency called `gvo_<name>` e.g. `gvo_Vulkan` (see [here](#some-important-points)):
``` cmake

add_executable(mymain src/main.cpp)

# print all the dependencies, include dirs and library files
foreach(GVO_DEP_NAME ${GVO_DEPS})
    target_link_libraries(mymain PUBLIC gvo_${GVO_DEP_NAME}) # link to specific dependecy
    string(TOUPPER ${GVO_DEP_NAME} GVO_DEP_NAME_CAP)
    message("${GVO_DEP_NAME}:")
    message("\tlib:     \"${${GVO_DEP_NAME_CAP}_LIBRARIES}\"")
    message("\tinclude: \"${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS}\"")
endforeach()
# OR link to all dependencies
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

## Currently provided dependencies (names):
- [assimp](https://github.com/assimp/assimp)
- [GLFW](https://github.com/glfw/glfw)
- [GLM](https://github.com/icaven/glm)
- [OpenAL](https://github.com/kcat/openal-soft)
- [OpenGL](https://github.com/Dav1dde/glad)
- [Vulkan](https://github.com/KhronosGroup/Vulkan-Headers)

## Variables
`<name>` is the name of the library e.g. `VULKAN_INCLUDE_DIRS`, `VULKAN_LIBRARIES`. 

The `GVO_SCRIPT_DIR` variable is set by gvo before including the script. containing directory of the script. (see [here](#some-important-points)).

These variables are set by the find script. They are already used by gvo target, but you can use them too:
| variable | description |
| :- | :- |
| `<name>_INSTALL_INCLUDE_DIRS` | controlls if gvo should install `<name>_INCLUDE_DIRS` |
| `<name>_INSTALL_LIBS` | controlls if gvo should install `<name>_LIBRARIES` |
| `<name>_INCLUDE_DIRS` | variable / list of dependency include directories. Used as include directories in gvo target. |
| `<name>_LIBRARIES` | variable / list with the library files of the dependency. gvo will link to them. Will be installed. |
---

Script-specific variables:
| variable | description | default |
| :- | :- | :- |
| `ASSIMP_BUILD_TESTS` |  | OFF |
| `ASSIMP_WARNINGS_AS_ERRORS` |  | OFF |
| `ASSIMP_BUILD_ASSIMP_VIEW` | `¯\_(ツ)_/¯` | OFF |
| `GLAD_API` | what [glad api](https://glad.dav1d.de/) to use. | gl:core=3.3 |
---

## Some important points
- gvo also installs any file in the `<name>_LIBRARIES` directory with `.lib .dll .dylib .a .so .framework` extensions (including double extensions, e.g. `.dll.a`) into the `gvo/lib` directory.

- gvo creates `gvo_<name>` interface library containing `<name>_LIBRARIES` and `<name>_INCLUDE_DIRS` for every dependency and `gvo` interface library containing all `gvo_<name>` libraries.

- gvo will only use initialised (`if(VAR)`) variables.

- User / cmake scripts could also set `<name>_INCLUDE_DIRS` and `<name>_LIBRARIES`, and these should not be overridden (currently they are not. It depends on the find script). 
I recommend using the following in find scripts:
``` cmake
if(NOT VULKAN_INCLUDE_DIRS)
# do someting and set VULKAN_INCLUDE_DIRS
endif()
```

- When writing scripts, you should use GVO_SCRIPT_DIR instead of CMAKE_CURRENT_SOURCE_DIR to get the actual directory of the script, as the scripts are included. 

- When using gvo's build-in scripts, you need to specify gvo's script directory:
``` cmake
gvo_find_dependencies(DEPENDENCIES ... SCRIPT_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/gvo/scripts)
```
- gvo build-in scripts use the FetchContent module to download dependencies, which is already included.
- gvo build-in scripts will only download dependencies if the corresponding `dependencies/<name>` exists.

## Troubleshooting
Fixes for known issues.


*if  you found any kind of bug / flaw or have questions please, create github issue or maybe even a pr )*
