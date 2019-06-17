#!/bin/bash

set -xeuo pipefail

export CONDA_BUILD_SYSROOT="$(${CC} --print-sysroot)"

export CFLAGS="${CFLAGS} -I${CONDA_BUILD_SYSROOT}/usr/include"
export LDFLAGS="${LDFLAGS} -L${CONDA_BUILD_SYSROOT}/usr/lib64"

CUDA_CONFIG_ARG=""
if [ ${ucx_proc_type} == "gpu" ]; then
    export CFLAGS="${CFLAGS} -I${CUDA_HOME}/include"
    CUDA_CONFIG_ARG="--with-cuda=${CUDA_HOME}"
fi

# Disable CMA to workaround an upstream bug.
# xref: https://github.com/openucx/ucx/issues/3391
# xref: https://github.com/openucx/ucx/pull/3424

cd "${SRC_DIR}/ucx"
./autogen.sh
./configure \
    --build="${BUILD}" \
    --host="${HOST}" \
    --prefix="${PREFIX}" \
    --disable-cma \
    --enable-mt \
    --with-gnu-ld \
    --with-rdmacm="/usr" \
    ${CUDA_CONFIG_ARG}

make -j${CPU_COUNT}
make install
