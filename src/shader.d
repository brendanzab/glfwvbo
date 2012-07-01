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
    
    string m_vsPath, m_fsPath;
    
public:
    
    @property GLuint programID() { return program; }
    
    this(string vsPath, string fsPath) {
        m_vsPath = vsPath;
        m_fsPath = fsPath;
        
        init();
    }
    
    void bind() {
        glUseProgram(program);
    }
    
    void unbind() {
        glUseProgram(0);
    }
    
    ~this() {
        writefln("Destroying shader");
        
        glDetachShader(program, vertexShader);
        glDetachShader(program, fragmentShader);
        
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        glDeleteProgram(program);
    }
    
private:
    
    void init() {
        program = glCreateProgram();
        
        vertexShader = createShader(GL_VERTEX_SHADER, m_vsPath);
        fragmentShader = createShader(GL_FRAGMENT_SHADER, m_fsPath);
        
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        
        // Bind attributes and fragment data
        glBindAttribLocation(program, 0, "in_Position");
        glBindFragDataLocation(program, 0, "out_Color");
        
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