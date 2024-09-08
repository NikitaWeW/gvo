# GVO - cmake glfw vulkan opengl setup
This project provides [vulkan headers](https://github.com/KhronosGroup/Vulkan-Headers), [vulkan loader](https://github.com/KhronosGroup/Vulkan-Loader), [glfw](https://github.com/glfw/glfw) git submodules, [glad opengl loader library](https://glad.dav1d.de/), and scripts to find them. 

User / cmake script could also set Xxx_INCLUDE_DIRS and Xxx_LIBRARIES and these wont overrride. 

You can use it however you want buti recommend add gvo as submodule and use it as cmake subdirectory

## Using gvo
First, clone it with **recursive** option because gvo has submodules.
```
git clone --recursive https://github.com/NikitaWeW/gvo.git
```
Here is some basic gvo usage:
``` cmake
set(VULKAN ON) # set requiered dependencies
set(OPENGL OFF)

add_subdirectory(gvo) # add gvo as subdirectory. it will create "gvo" interface target.

add_executable(mymain src/main)

target_link_libraries(mymain gvo) # link to gvo target. it will connect both include dirs and libraris.
```
If you want to use your own libraries or sources, you can specify the path to by setting `Xxx_INCLUDE_DIRS` for include directories and `Xxx_LIBRARIES` for libraris. Where `Xxx` is the name of the library e.g. `VULKAN_INCLUDE_DIRS`, `VULKAN_LIBRARIES`.

## Options
| option | description |
| :----- | :---------- |
| GLFW | you use glfw. if set to false glad wont build and include directories wont set. | 
| VULKAN | you use vulkan. if set to false glad wont build and include directories wont set. | 
| OPENGL | you use opengl. if set to false glad wont build and include directories wont set. |
---

*if  you found any kind of error/flaw please, create github issue or maybe even a pr )*


