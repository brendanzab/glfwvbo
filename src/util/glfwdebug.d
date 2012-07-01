module glfwvbo.util.glfwdebug;

import glfwvbo.util.prettyout;

import std.stdio, std.conv, std.string;
import derelict.glfw3.glfw3;

void writeGLFWInfo() {
    if (!DerelictGLFW3.isLoaded()) {
        writefln(errorString("DerelictSDL2 is not loaded!"));
        return;
    }
    
    // Get desktop video mode
    GLFWvidmode dtmode;
    glfwGetDesktopMode(&dtmode);
    
    // Get all available video modes
    int MAX_NUM_MODES = 400;
    GLFWvidmode* modes;
    int modecount = glfwGetVideoModes(modes, MAX_NUM_MODES);
    
    // Print GLFW info
    writefln(headingString("GLFW"));
    writefln("Version:  %s", to!string(glfwGetVersionString()));
    writefln("Desktop mode: %s", getModeString(dtmode));
    writefln("Available modes: %d", modecount);
    foreach (int i; 0..modecount) {
        writefln(" %3d - %s", i, getModeString(modes[i]));
    }
    writeln();
}

void writeGLFWErrors()() {
    int errorID = glfwGetError();
    while (errorID != GLFW_NO_ERROR)
    {
        writeln(errorString("GLFW Error: "), to!string(glfwErrorString(errorID)));
        errorID = glfwGetError();
    }
}

private {
    
    string getModeString(GLFWvidmode mode) {
        return format(
            "%d x %d, %d bits",
            mode.width, mode.height,
            mode.redBits + mode.greenBits + mode.blueBits);
    }

}
