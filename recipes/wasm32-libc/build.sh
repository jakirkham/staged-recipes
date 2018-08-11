#!/usr/bin/env bash

unset ARCH
unset OSX_ARCH
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

export CC="${BUILD_PREFIX}/bin/clang"
export LD="${BUILD_PREFIX}/bin/lld"

./configure --prefix="${PREFIX}"  \
            --build="${BUILD}"    \
            --host="${HOST}"      \
            || { cat config.log; exit 1; }
make -j${CPU_COUNT} ${VERBOSE_AT}
make install
