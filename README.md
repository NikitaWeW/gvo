# GVO - cmake glfw vulkan opengl (and other) setup
This project provides [these dependencies](#currently-supported-dependencies), and scripts to build and find them. 

You set the GVO_DEPS and add gvo as subdirectory. gvo will iterate over GVO_DEPS and automaticly include all the requiered scripts that will set [output variables](#output) and use these.

You can use it however you like, but I recommend adding gvo as a submodule and using it as a cmake subdirectory.

## Using gvo
First, clone it with **recursive** option because gvo has submodules.
```
git clone --recursive https://github.com/NikitaWeW/gvo.git
```

Here is some basic gvo usage:
``` cmake
set(GVO_DEPS Vulkan OpenGL GLFW Logger assimp OpenAL GLM) # set requiered dependencies

add_subdirectory(gvo) # add gvo as subdirectory. it will create "gvo" interface target.

add_executable(mymain src/main.cpp)

target_link_libraries(mymain gvo) # link to gvo target. it will connect both include dirs and libraris.
```
## Input
`GVO_DEPS` should be set before adding gvo subdirectory. `GVO_DEPS` list constains [names of the dependencies](#currently-supported-dependencies). Its used to locate and include find scripts (these build the dependency and set [output variables](#output)). 
## Currently supported dependencies:
- [assimp](https://github.com/assimp/assimp)
- [GLFW](https://github.com/glfw/glfw)
- [GLM](https://github.com/icaven/glm)
- [Logger](https://github.com/yksz/c-logger)
- [OpenAL](https://github.com/kcat/openal-soft)
- [OpenGL](https://glad.dav1d.de/)
- [Vulkan](https://github.com/KhronosGroup/Vulkan-Headers)


## Output
The variables below are set by the find script and already included / linked to the `gvo` target / installed in gvo directory 

`Xxx` is the name of the library e.g. `VULKAN_INCLUDE_DIRS`, `VULKAN_LIBRARIES`. 
| variable | description |
| :- | :- |
| `Xxx_INCLUDE_DIRS` | variable / list with include directories of the dependency |
| `Xxx_LIBRARIES` | variable / list with library files of the dependency (Only for linking) |
| `Xxx_LIBRARY_FILES_TO_INSTALL` | variable / list with the library files to install in `gvo/lib` |
| `Xxx_FILES_TO_INSTALL` | variable / list with the additional files to install in `gvo` |
| `Xxx_DIRECTORIES_TO_INSTALL` | variable / list with the additional directories to install in `gvo` |
---

User / cmake scripts could also set Xxx_INCLUDE_DIRS and Xxx_LIBRARIES, and these should not be overridden (currently they are not overridden. That depends on the find script). 

Also, you can use `Xxx_INCLUDE_DIRS` and `Xxx_LIBRARIES` for your purposes:
``` cmake
# print all the dependencies, include dirs and library files
foreach(GVO_DEP_NAME ${GVO_DEPS})
    string(TOUPPER ${GVO_DEP_NAME} GVO_DEP_NAME_CAP)
    message("${GVO_DEP_NAME}:")
    message("\tlib:     \"${${GVO_DEP_NAME_CAP}_LIBRARIES}\"")
    message("\tinclude: \"${${GVO_DEP_NAME_CAP}_INCLUDE_DIRS}\"")
endforeach()
```
example output:
```
OpenGL:
        lib:     "glad"
        include: "H:/me/gladopengl/include"
GLFW:
        lib:     "glfw"
        include: "H:/me/glfw/include"
Logger:
        lib:     "logger"
        include: "H:/me/gvo/dependencies/c-logger/src/"
GLM:
        lib:     ""
        include: "H:/me/gvo/dependencies/glm/glm/"
OpenAL:
        lib:     "OpenAL"
        include: "H:/me/gvo/dependencies/OpenAL/include/"
assimp:
        lib:     "assimp"
        include: "H:/me/gvo/build/gvo/assimp/include/"
```
*Note, that glad, glfw, etc. are just target names.*

## Installing
Gvo installs in `prefix/gvo` directory. It installs dependencies include directories in `prefix/gvo/include` directory, library files in `prefix/gvo/lib` directory. 

*if  you found any kind of bug / flaw or have questions please, do create github issue or maybe even a pr )*


