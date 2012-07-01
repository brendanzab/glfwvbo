EXECUTABLE_NAME 	= glfwvbo
BUILD_DIRECTORY 	= build
D_SOURCE_FILES 		= src/main.d src/util/*.d -Isrc
DMD_BUILD_FLAGS 	= -gc

# Change based on your derelict directory
DER2_PATH 			= /usr/local/src/Derelict3
DER2_LINKER_FLAGS 	= -L-lDerelictGL3 -L-lDerelictGLFW3 -L-lDerelictUtil

# Execute build
all: 
	dmd $(D_SOURCE_FILES) $(DMD_BUILD_FLAGS) \
	-I$(DER2_PATH)/import -L-L$(DER2_PATH)/lib $(DER2_LINKER_FLAGS) \
	-od$(BUILD_DIRECTORY) -of$(BUILD_DIRECTORY)/$(EXECUTABLE_NAME)
	
run:
	@./build/glfwvbo