module glfwvbo.main;

import glfwvbo.shader;
import glfwvbo.util.gldebug;
import glfwvbo.util.glfwdebug;
import glfwvbo.util.prettyout;

import std.conv, std.stdio, std.string;
import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;


string programName = "glfw vbo test";
bool running = true;

GLFWwindow window;
int width = 640;
int height = 480;


void main() {
    init();
    
    // Main game loop
    while (glfwIsWindow(window) && running) {
        // Poll events
        glfwPollEvents();
        
        render();
        
    }
    
    cleanup();
}

void init() {
    initGLFW();
    initOpenGL();
    initShaders();
    initBuffers();
}

void initGLFW(){
    
    // Initialise GLFW
    DerelictGLFW3.load();
    if(!glfwInit()) {
        writeGLFWErrors();
        throw new Exception(errorString("Failed to create glcontext"));
    }
    
    // Log hardware and version info
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
    
    // Setup input handling
    glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);
    glfwSetKeyCallback(&keyCallback);
    
}

void onKeyEvent(GLFWwindow window, int key, int action) {
    if (action != GLFW_PRESS) return;
    
    switch(key) {
        case GLFW_KEY_ESCAPE:
            running = false;
            break;
            
        default:
            break;
    }
}

extern(C) {
    void keyCallback(void* window, int key, int action) {
        onKeyEvent(window, key, action);
    }
}

void initOpenGL() {
    // Load DerelictGL3
    DerelictGL3.load();     // Load OpenGL functions from Version 1.1
    DerelictGL3.reload();   // Load OpenGL functions from Version 1.2+
    
    // Log version and display info
    writeGLInfo();
    
    // Set the viewport dimensions
    glViewport(0, 0, width, height);
    
    // Clear color buffer to dark grey
    glClearColor(0.2, 0.2, 0.2, 1);
}

// The handle for the shader program
Shader shader;

void initShaders() {
    shader = new Shader("resources/shader.vert", "resources/shader.frag");
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
    glBufferData(GL_ARRAY_BUFFER, vertexPositions.length * float.sizeof, vertexPositions.ptr, GL_STATIC_DRAW);
    
    // Set attribute-pointers to enable communication with the shader
    GLint positionlocation = glGetAttribLocation(shader.programID, "in_Position");
    glVertexAttribPointer(
        positionlocation,   // shader attribute
        4,                  // size
        GL_FLOAT,           // type
        GL_FALSE,           // normalized?
        0,                  // stride
        null                // array buffer offset
    );
    glEnableVertexAttribArray(positionlocation);
    
    // Cleanup
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
}

void render() {
    // Clear the window
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Activate the shader program
    shader.bind();
    
    // Draw the Vertex Array Object
    glBindVertexArray(vao);
    glDrawArrays(GL_TRIANGLES, 0, 3);   // Start at the 0th index and draw 3 verticies
    glBindVertexArray(0);
    
    // Disable the program
    shader.unbind();
    
    // Update the window
    glfwSwapBuffers();
    
    // Print out OpenGL errors if there are any
    writeGLError();
}

void cleanup() {
    writefln("Cleaning up OpenGL");
    glBindVertexArray(0);
    glDeleteVertexArrays(1, &vao);
    
    writefln("Terminating GLFW");
    glfwTerminate();
}