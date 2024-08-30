#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include "c-logger/logger.h"  // Include your logger header file
#include <cstdint>

int main() {
    // Initialize GLFW
    if (!glfwInit()) {
        LOG_FATAL("Failed to initialize GLFW");
        return -1;
    }

    // Make sure Vulkan is supported by GLFW
    if (!glfwVulkanSupported()) {
        LOG_FATAL("Vulkan not supported by GLFW");
        return -1;
    }

    // Vulkan instance creation
    VkInstance instance;
    VkApplicationInfo appInfo{};
    appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    appInfo.pApplicationName = "Vulkan Test";
    appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.pEngineName = "No Engine";
    appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.apiVersion = VK_API_VERSION_1_0;

    VkInstanceCreateInfo createInfo{};
    createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    createInfo.pApplicationInfo = &appInfo;

    uint32_t glfwExtensionCount = 0;
    const char** glfwExtensions;
    glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

    createInfo.enabledExtensionCount = glfwExtensionCount;
    createInfo.ppEnabledExtensionNames = glfwExtensions;
    createInfo.enabledLayerCount = 0;

    if (vkCreateInstance(&createInfo, nullptr, &instance) != VK_SUCCESS) {
        LOG_FATAL("Failed to create Vulkan instance");
        return -1;
    }

    // List available extensions
    uint32_t extensionCount = 0;
    vkEnumerateInstanceExtensionProperties(nullptr, &extensionCount, nullptr);
    std::vector<VkExtensionProperties> extensions(extensionCount);
    vkEnumerateInstanceExtensionProperties(nullptr, &extensionCount, extensions.data());

    LOG_INFO("Available Vulkan extensions:");
    for (const auto& extension : extensions) {
        LOG_DEBUG("\t%s", extension.extensionName);
    }

    // Clean up
    vkDestroyInstance(instance, nullptr);
    glfwTerminate();

    LOG_INFO("Vulkan setup was successful!");
    return 0;
}
