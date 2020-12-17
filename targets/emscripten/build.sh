#!/bin/bash

# Include the shared scripts and utility methods that are common to all platforms.
. ../../shared/shared-scripts.sh

# Make sure we have a 'build' folder.
if [ ! -d "build" ]; then
	mkdir build
fi

# Remove the 'out' folder if it exists.
if [ -d "out" ]; then
	rm -rf out
fi

# In order to find the Emscripten build tools, we need to configure some environment variables so they are available during the build. The required environment variables are initialized by sourcing the 'emsdk_env.sh' that ships with the Emscripten SDK.
pushd ../../third-party/emscripten
	echo "Configuring Emscripten environment variables"
	. ./emsdk_env.sh
popd

# Hop into the 'build' folder to start our CMake build.
pushd build
	
	echo "Path Location: ${EMSCRIPTEN}"
	EMSCRIPTEN_LOCATION=../../third-party/emscripten/upstream/emscripten

	# Because we sourced the Emscripten environment variables, we can use the 'EMSCRIPTEN' var to know where the current SDK can be found, which we need so we can locate the 'Emscripten.cmake' toolchain file.
	# 10/29/202 - Couldnt locate the 'EMSCRIPTEN' variable so we are setting the path ourselves
	EMSCRIPTEN_CMAKE_PATH=${EMSCRIPTEN_LOCATION}/cmake/Modules/Platform/Emscripten.cmake

	# We ask CMake to configure itself against the parent folder, but unlike our other platform targets, we will tell CMake to use the Emscripten CMake toolchain which knows how to perform Emscripten builds.
	echo "Emscripten CMake path: ${EMSCRIPTEN_CMAKE_PATH}"
	cmake -DCMAKE_TOOLCHAIN_FILE=${EMSCRIPTEN_CMAKE_PATH} ..

	# Start the actual build.
	echo "Building project ..."
	make
popd