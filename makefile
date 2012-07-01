EXECUTABLE_NAME 	= glfwvbo
BUILD_PATH		 	= build
D_SOURCE_FILES 		= src/*.d src/util/*.d -Isrc
DMD_BUILD_FLAGS 	= -gc

# Change based on your derelict directory
DER2_PATH 			= /usr/local/src/Derelict3
DER2_LINKER_FLAGS 	= -L-lDerelictGL3 -L-lDerelictGLFW3 -L-lDerelictUtil

all:
	dmd $(DMD_BUILD_FLAGS) \
	$(D_SOURCE_FILES) \
	-I$(DER2_PATH)/import \
	-L-L$(DER2_PATH)/lib \
	$(DER2_LINKER_FLAGS) \
	-od$(BUILD_PATH) -of$(BUILD_PATH)/$(EXECUTABLE_NAME)
	
run:
	@./$(BUILD_PATH)/$(EXECUTABLE_NAME)

br: all run