module glfwvbo.main;

import glfwvbo.util.gldebug;
import glfwvbo.util.glfwdebug;
import glfwvbo.util.prettyout;

import std.conv, std.stdio, std.string, std.file;
import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;


string programName = "glfw vbo test";
bool running = true;

GLFWwindow window;
int width = 640;
int height = 480;
    
void initGLFW(){
    // Initialise GLFW
    DerelictGLFW3.load();
    if(!glfwInit()) {
        writeGLFWErrors();
        throw new Exception(errorString("Failed to create glcontext"));
    }
    
    writeGLFWInfo();
    
    // Specify the profile that GLFW will load
    glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, 3);
    glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, 2);
    // OS X 10.7+ only supports the forward compatible core profile
    glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwOpenWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
    // Create a GLWF window and OpenGL context
    window = glfwOpenWindow(width, height, GLFW_WINDOWED, programName.ptr, null);
    if(!window) {
        writeGLFWErrors();
        throw new Exception(errorString("Failed to create window"));
    }

    // Enable vertical sync (on cards that support it)
    glfwSwapInterval(1);
    
}

void initOpenGL() {
    // Initialise OpenGL
    DerelictGL3.load();     // Load OpenGL functions from Version 1.1
    DerelictGL3.reload();   // Load OpenGL functions from Version 1.2+
    
    // Log GLFW and GL info
    writeGLInfo();
    
    // Set the viewport dimensions
    glViewport(0, 0, width, height);
    
    // Clear color buffer to dark grey
    glClearColor(0.2, 0.2, 0.2, 1);
}

GLuint createShader(GLenum shaderType, string shaderFile) {
    // Create the OpenGL shader object
    GLuint shader = glCreateShader(shaderType);
    
    // Read the shader from the file
    writefln(headingString("Reading shader from %s:"), shaderFile);
    const char* shaderFileData = toStringz(readText(shaderFile));
    writefln("%s\n", to!string(shaderFileData));
    glShaderSource(
        shader,             // The shader object
        1,                  // The number of strings (there can be multiple strings in one object)
        &shaderFileData,    // The shader data
        null                // Assume that the string is null-terminated
    );
    glCompileShader(shader);
    
    // Throw an exception if the compilation fails
    GLint succeeded;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &succeeded);
    if (!succeeded) {
        // Get log-length
        GLint len;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &len);
        
        // Get info log and throw exception
        char[] log=new char[len];
        glGetShaderInfoLog(shader, len, null, cast(char*)log);
        throw new Exception(format("%s %s", errorString("GLSL Compile failure:"), log));
    }
    
    return shader;
}

GLuint createProgram(GLuint shaders[]) {
    // Create an empty program object
    GLuint program = glCreateProgram();
    
    // Attach the shader objects to the program
    foreach (GLuint s; shaders)
        glAttachShader(program, s);
    
    // Bind the attribute so that it can be used in the GLSL shader
    glBindAttribLocation(program, 0, "position");
    // Bind the fragment shader's output
    glBindFragDataLocation(program, 0, "fragColor");
    
    glLinkProgram(program);
    
    // Throw an exception if the linking fails
    GLint succeeded;
    glGetProgramiv(program, GL_LINK_STATUS, &succeeded);
    if (!succeeded) {
        // Get log-length
        GLint len;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &len);
        
        // Get info log and throw exception
        char[] log=new char[len];
        glGetProgramInfoLog(program, len, null, cast(char*)log);
        throw new Exception(format("%s %s", errorString("Program Linker failure:"), log));
    }
    
    return program;
}

// The handle for the shader program
GLuint shaderProgram;
GLuint shaders[];

void initShaders() {
    shaders ~= createShader(GL_VERTEX_SHADER, "resources/shader.vert");
    shaders ~= createShader(GL_FRAGMENT_SHADER, "resources/shader.frag");
    
    shaderProgram = createProgram(shaders);
}

// 4D positions of the verticies
const float vertexPositions[] = [
    0.75,  0.75,  0.0,  1.0,
    0.75, -0.75,  0.0,  1.0,
   -0.75, -0.75,  0.0,  1.0
];

// The handles for the buffer objects
GLuint vao;

void initBuffers() {
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);
    
    // Create the buffer object and bind the vertex data
    GLuint positionBufferObject;
    glGenBuffers(1, &positionBufferObject);
    glBindBuffer(GL_ARRAY_BUFFER, positionBufferObject);
    glBufferData(GL_ARRAY_BUFFER, vertexPositions.length , vertexPositions.ptr, GL_STATIC_DRAW);
    
    // Set attribute-pointer
    GLint positionLocation = glGetAttribLocation(shaderProgram, "position");
    glVertexAttribPointer(
        positionLocation,   // shader attribute
        4,                  // size
        GL_FLOAT,           // type
        GL_FALSE,           // normalized?
        0,                  // stride
        null                // array buffer offset
    );
    glEnableVertexAttribArray(positionLocation);
    
    // Cleanup
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    writeGLErrors();
    
}

void render() {
    // Clear the window
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Activate the shader program
    glUseProgram(shaderProgram);
    
    // Draw the Vertex Array Object
    glBindVertexArray(vao);
    glDrawArrays(GL_TRIANGLES, 0, 3);   // Start at the 0th index and draw 3 verticies
    glBindVertexArray(0);
    
    // Disable the program
    glUseProgram(0);
    
    // Update the window
    glfwSwapBuffers();
}

void init() {
    initGLFW();
    initOpenGL();
    initShaders();
    initBuffers();
}

void cleanup() {
    
    writefln("Cleaning up OpenGL");
    
    glBindVertexArray(0);
    glDeleteVertexArrays(1, &vao);
    
    glUseProgram(0);
    glDeleteProgram(shaderProgram);
    
    // Detach the shaders
    foreach (GLuint s; shaders) {
        glDetachShader(shaderProgram, s);
        glDeleteShader(s);
    }
    
    writefln("Terminating GLFW");
    glfwTerminate();
}

void main() {
    init();
    
    // Main game loop
    while (glfwIsWindow(window) && running) {
        // Poll events
        glfwPollEvents();
        
        render();
        
        //break;
    }
    
    cleanup();
}