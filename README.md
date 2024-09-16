# outdated. working on a new one
# GVO - cmake glfw vulkan opengl (and other) setup
This project provides [these dependencies]() as git submodules, and scripts to build and find them. 

User / cmake script could also set Xxx_INCLUDE_DIRS and Xxx_LIBRARIES and these wont overrride. 

You can use it however you want buti recommend add gvo as submodule and use it as cmake subdirectory

## Using gvo
First, clone it with **recursive** option because gvo has submodules.
```
git clone --recursive https://github.com/NikitaWeW/gvo.git
```
All you need is set GVO_DEPS list and add gvo as subdirectory. gvo will iterate over GVO_DEPS and automaticly set include directories and  
Here is some basic gvo usage:
``` cmake
set(GVO_DEPS Vulkan OpenGL GLFW Logger assimp OpenAL GLM) # set requiered dependencies

add_subdirectory(gvo) # add gvo as subdirectory. it will create "gvo" interface target.

add_executable(mymain src/main.cpp)

target_link_libraries(mymain gvo) # link to gvo target. it will connect both include dirs and libraris.
```

## Output va
If you want to use your own libraries or sources, you can specify the path to by setting `Xxx_INCLUDE_DIRS` for include directories and `Xxx_LIBRARIES` for libraris. 

Where `Xxx` is the name of the library e.g. `VULKAN_INCLUDE_DIRS`, `VULKAN_LIBRARIES` . 

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

*if  you found any kind of bug / flaw please, do create github issue or maybe even a pr )*


