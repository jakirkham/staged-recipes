#!/bin/bash

export CMAKE_CONFIG="Release"
mkdir "build_${CMAKE_CONFIG}"
cd "build_${CMAKE_CONFIG}"

export CXXFLAGS="-fPIC ${CXXFLAGS}"
export CFLAGS="-fPIC ${CFLAGS}"

cmake \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_BUILD_TYPE:STRING="${CMAKE_CONFIG}" \
    -DINSTALL_HEADERS:BOOL=ON \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DBUILD_STATIC_LIBS:BOOL=ON \
    -DBUILD_TESTING:BOOL=ON \
    "${SRC_DIR}"

make
ctest
make install
