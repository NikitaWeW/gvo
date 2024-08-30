## about
*note: this project is currently in development*

Hi. Thank you for cloning/visiting this project. That's the setup for [glfw](https://www.glfw.org/), [vulkan](https://www.vulkan.org/), and [opengl](https://www.khronos.org/opengl/).
## build
If you want to use glfw/vulkan/opengl provided by this project just run
```bash
mkdir build
cmake -S . -B build
cmake --build build
build/gvo
```
## Dependencies
This project has everything to compile and run on windows.

If you want to use your own libraries or sources, you can specify the path to them using
``` bash
cmake -S . -B build -D VARIABLE='path/to'
```
Here's all the variables that you can set:
| name | description | example |
| :--- | :---------- | :------ |
| SRC | path to your source files | `-D SRC='main.c other.cpp'` | 
| SRC_DEPS | path to your additional source/object files (made to separate your source files and small dependencies) | `-D SRC_DEPS='logger.o loggerconf.c'` | 
| GLFW_INCLUDE_DIR | path to glfw include folder | `-D GLFW_INCLUDE_DIR='glfw/include'` |
| GLFW_BIN | path to glfw loader library file | `-D GLFW_BIN='glfw/build/src/libglfw.a'` |
| GL_INCLUDE_DIR | path to opengl loader include folder | `-D GL_INCLUDE_DIR='glad/lib/libglad.a'` |
| GL_BIN | path to opengl library file | `-D GL_BIN='glad/include'` |
| VULKAN_INCLUDE_DIR | path to vulkan include folder | `-D VULKAN_INCLUDE_DIR='VulkanSDK/Include'` |
| VULKAN_BIN | path to vulkan library file  | `-D VULKAN_BIN='VulkanSDK/Lib/vulkan-1.lib'` |
---
*if  you found any kind of error/flaw feel free to create github issue or maybe even a pr )*


