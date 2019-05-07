#!/bin/bash

# http://xgboost.readthedocs.io/en/latest/build.html

if [[ $(uname) == Darwin ]]
then
    # this seems to be expected by clang when linking
    ln -s ${PREFIX}/lib/libomp.dylib ${PREFIX}/lib/libgomp.dylib
fi

cmake -G "Unix Makefiles" \
      -D CMAKE_BUILD_TYPE:STRING="Release" \
      -D CMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
      -D CMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
      -D USE_CUDA:BOOL=ON \
      -D CUDA_TOOLKIT_ROOT_DIR:PATH="${CUDA_HOME}" \
      -D CUDA_HOST_COMPILER:PATH="${CXX}" \
      -D CMAKE_CUDA_COMPILER:PATH="${CUDA_HOME}/bin/nvcc" \
      -D CUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF \
      -D CUDA_NVCC_FLAGS:STRING="-I${PREFIX}/include" \
      -D CMAKE_CXX_STANDARD:STRING="11" \
      -D CMAKE_CUDA_STANDARD:STRING="11" \
      -D USE_NCCL:BOOL=ON \
      -D NCCL_ROOT:PATH="${PREFIX}" \
      "${SRC_DIR}"
make -j${CPU_COUNT}
