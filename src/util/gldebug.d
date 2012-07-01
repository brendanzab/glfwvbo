module glfwvbo.util.gldebug;

import glfwvbo.util.styledout;

import std.stdio, std.conv;
import derelict.opengl3.gl3;

void writeGLErrors() {
    GLenum glError = glGetError();
    while (glError != GL_NO_ERROR) {
        writeln(errorString("OpenGL Error: "), glErrorString(glError));
        glError = glGetError();
    }
}

void writeGLInfo() {
    if (!DerelictGL3.isLoaded()) {
        writefln(errorString("DerelictGL3 is not loaded!"));
        return;
    }

    // Print OpenGL and GLSL version
    writefln(headingString("OpenGL"));
    writefln("Vendor:   %s", to!string(glGetString(GL_VENDOR)));
    writefln("Renderer: %s", to!string(glGetString(GL_RENDERER)));
    writefln("Version:  %s", to!string(glGetString(GL_VERSION)));
    writefln("GLSL:     %s", to!string(glGetString(GL_SHADING_LANGUAGE_VERSION)));
    writeln();
}

string glErrorString(GLenum glError) {
    switch(glError) {
        case GL_NO_ERROR:
            return "GL_NO_ERROR";
            
        case GL_INVALID_ENUM:
            return "GL_INVALID_ENUM";
            
        case GL_INVALID_VALUE:
            return "GL_INVALID_VALUE";
            
        case GL_INVALID_OPERATION:
            return "GL_INVALID_OPERATION";
            
        case GL_INVALID_FRAMEBUFFER_OPERATION:
            return "GL_INVALID_FRAMEBUFFER_OPERATION";
            
        case GL_OUT_OF_MEMORY:
            return "GL_OUT_OF_MEMORY";
            
        default:
            return "Unknown Error";
    }
}