# !/bin/sh

EXECUTABLE_NAME="glfwvbo"
BUILD_DIRECTORY="build"
D_SOURCE_FILES="src/*.d"

# Change based on your derelict directory
DER2_PATH="/usr/local/src/Derelict3"
DER2_LINKER_FLAGS="-L-lDerelictGL3 -L-lDerelictGLFW3 -L-lDerelictUtil"

# Execute build
/usr/local/bin/dmd -gc  \
${D_SOURCE_FILES}       \
-I${DER2_PATH}/import   \
-L-L${DER2_PATH}/lib    \
${DER2_LINKER_FLAGS}    \
-od${BUILD_DIRECTORY}   \
-of${BUILD_DIRECTORY}/${EXECUTABLE_NAME}

# # Run executable
# ./${BUILD_DIRECTORY}/${EXECUTABLE_NAME}