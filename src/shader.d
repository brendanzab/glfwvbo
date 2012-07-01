module glfwvbo.shader;

import glfwvbo.util.gldebug;
import glfwvbo.util.prettyout;

import std.stdio, std.string, std.file;
import derelict.opengl3.gl3;

class Shader {
    
private:
    GLuint program;
    GLuint vertexShader;
    GLuint fragmentShader;
    
    string vsPath, fsPath;
    
public:
    
    this(string vsPath, string fsPath) {
        this.vsPath = vsPath;
        this.fsPath = fsPath;
        
        init();
    }
    
    /// The program handle
    @property GLuint programID() { return program; }
    
    /// Enable the shader
    void bind() {
        glUseProgram(program);
    }
    
    /// Disable the shader
    void unbind() {
        glUseProgram(0);
    }
    
    /// Cleans up the shader
    ~this() {
        writefln("Destroying shader");
        
        glDetachShader(program, vertexShader);
        glDetachShader(program, fragmentShader);
        
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        glDeleteProgram(program);
    }
    
private:
    
    /// Initialise the shader program
    void init() {
        program = glCreateProgram();
        
        vertexShader = createShader(GL_VERTEX_SHADER, vsPath);
        fragmentShader = createShader(GL_FRAGMENT_SHADER, fsPath);
        
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        
        glBindAttribLocation(program, 0, "in_Position");
        glBindFragDataLocation(program, 0, "out_Color");
        
        // Link and log errors
        glLinkProgram(program);
        writeProgramLog(program);
    }
    
    GLuint createShader(GLenum shaderType, string shaderFile) {
        // Create the OpenGL shader object
        GLuint shader = glCreateShader(shaderType);
        
        // Read the shader from the file
        writefln("Reading shader from %s", shaderFile);
        const char* shaderFileData = toStringz(readText(shaderFile));
        glShaderSource(shader, 1, &shaderFileData, null);
        
        // Compile and log errors
        glCompileShader(shader);
        writeShaderLog(shader);
        
        return shader;
    }
    
    void writeShaderLog(GLuint shader) {
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
    }
    
    void writeProgramLog(GLuint program) {
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
    }
}