#!/bin/bash

set -euo pipefail


#CONDA_BUILD_SYSROOT
CONDA_BUILD_SYSROOT="$(${CC} --print-sysroot)"
mkdir -p "${PREFIX}/lib"
mkdir -p "${PREFIX}/include"
#mkdir -p "${CONDA_BUILD_SYSROOT}/lib"
#mkdir -p "${CONDA_BUILD_SYSROOT}/include"


#ln -s /usr/lib64/librdmacm.so* ${PREFIX}/usr/lib64
#ln -s /usr/lib64/libibverbs.so* ${PREFIX}/usr/lib64
#ln -s /usr/include/rdma ${PREFIX}/usr/include
#ln -s /usr/include/infiniband ${PREFIX}/usr/include

ln -s /usr/lib64/librdmacm.so* ${PREFIX}/lib
ln -s /usr/lib64/libibverbs.so* ${PREFIX}/lib
ln -s /usr/lib64/libnl.so ${PREFIX}/lib/libnl.so.1
ln -s /usr/include/rdma ${PREFIX}/include
ln -s /usr/include/infiniband ${PREFIX}/include

CUDA_CONFIG_ARG=""
if [ ${ucx_proc_type} == "gpu" ]; then
    CUDA_CONFIG_ARG="--with-cuda=${CUDA_HOME}"
fi

./autogen.sh

export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,$PREFIX/lib"

./configure \
    --build="${BUILD}" \
    --host="${HOST}" \
    --prefix="${PREFIX}" \
    --disable-cma \
    --disable-numa \
    --enable-mt \
    --enable-examples \
    --with-gnu-ld \
    --with-rdmacm=${PREFIX} \
    --with-verbs=${PREFIX} \
    ${CUDA_CONFIG_ARG}

make -j${CPU_COUNT}
make install

#ln -s ${PREFIX}/usr/lib64/librdmacm.so* ${PREFIX}/lib
#ln -s /usr/include/rdma ${PREFIX}/usr/include
#ln -s /usr/include/infiniband ${PREFIX}/usr/include


