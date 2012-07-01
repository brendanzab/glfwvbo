# glfwvbo

This project is illustrate how to use VBOs and Shaders with Derelict3.

*I still haven't got this working*. All it does is display a blank screen. Any assistance would be most appreaciated.

I am very much a beginner, so I would caution against considering my work an example of best practices. You have been warned! :)

I've only tested this on OSX - there might need to be modifications to it so that it can be run on Windows and Linux.

# Instructions

1. Edit the makefile to point to your Derelict installation
2. Build the project: `$ make`
3. ...then run it: `$ make run`

If you use Sublime Text, for convenience I've set it up so that it points to the Derelict3 and Phobos directories on my machine. You'll probably want to change those as well.

# Dependencies

- D2: http://dlang.org/
- Derelict3: https://github.com/aldacron/Derelict3
- GLFW: https://github.com/elmindreda/glfw